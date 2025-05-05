import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme/custom_theme.dart';
import '../../utils/circular_progress.dart';
class LeafSpotDetectionScreen extends StatefulWidget {
  final String model;
  final String label;
  final bool isDisease;

  LeafSpotDetectionScreen({Key? key, required this.model, required this.label, required this.isDisease}) : super(key: key);

  @override
  State<LeafSpotDetectionScreen> createState() => _LeafSpotDetectionScreenState();
}

class _LeafSpotDetectionScreenState extends State<LeafSpotDetectionScreen> with TickerProviderStateMixin {
  List<Map<String, dynamic>> yoloResults = [];
  final FlutterVision vision = FlutterVision();
  File? imageFile;
  int imageHeight = 1;
  int imageWidth = 1;
  bool isLoaded = false;
  bool _processing = false;
  String? _disease;
  double _confidence = 0.0;
  String? _recommendation;
  String? _model;
  String? _label;
  TabController? _tabController;
  bool? isDisease;

  @override
  void initState() {
    super.initState();
    initModel();
    loadYoloModel().then((value) {
      setState(() {
        isLoaded = true;
      });
    });
    _tabController = TabController(length: 4, vsync: this);
    

  }

  initModel() async {
   _model = widget.model;
   _label = widget.label;
   isDisease = widget.isDisease;
  }

  @override
  void dispose() async {
    super.dispose();
    vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!isLoaded) {
      loadYoloModel();
      return Scaffold(
        appBar: AppBar(
          title: FxText.titleLarge(
            'Model has not yet loaded',
            color: Colors.white,
            fontWeight: 900,
          ),
          backgroundColor: CustomTheme.primary,
        ),
        body: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );

    }
    return Scaffold(
      appBar: AppBar(
        title: FxText.titleLarge(
        'NARO AI VISION',
        color: Colors.white,
        fontWeight: 900,
      ),
        backgroundColor: CustomTheme.primary,
          actions: [
      PopupMenuButton<String>(
          onSelected: (String choice) {
            // Handle the selected menu item here
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'Disease Identifier',
                child: Text('Disease Identifier',
                  style: TextStyle(
                      color: isDisease!? Colors.green: Colors.black
                  ),
                ),
                onTap: (){
                  _model = 'assets/aimodel/leafspot_identifier_model.tflite';
                  _label = 'assets/aimodel/labels_leafspot.txt';
                  setState(() {
                    isDisease = true;
                    imageFile = null;
                    _confidence = 0.0;
                    _disease = null;
                    _recommendation =null;
                    yoloResults = [];
                  });
                  loadYoloModel();
                },
              ),
              PopupMenuItem<String>(
                value: 'Variety Identifier',
                child: Text('Variety Identifier',
                  style: TextStyle(
                    color: isDisease!? Colors.black: Colors.green
                  ),
                ),
                onTap: (){
                  _model = 'assets/aimodel/variety_identifier_model.tflite';
                  _label = 'assets/aimodel/labels_variety.txt';
                  setState(() {
                    isDisease = false;
                    imageFile = null;
                    _confidence = 0.0;
                    _disease = null;
                    _recommendation =null;
                    yoloResults = [];
                  });
                  loadYoloModel();
                },
              ),
              const PopupMenuItem<String>(
                value: 'Yield Predictor',
                child: Text('Yield Predictor'),
              ),

            ];
          }
            )
    ]
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              fit: StackFit.loose,
              children: [
                imageFile != null ? Image.file(
                  imageFile!,
                  fit: BoxFit.fill,
                  scale: 0.4,
                )
                    :Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.width* 0.8,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: (imageFile!= null)
                          ? DecorationImage(
                        image: FileImage(imageFile!),
                        fit: BoxFit.cover,
                      )
                          : null,
                      color: imageFile == null? Color(0xffC4C4C4).withOpacity(0.2): Colors.transparent,
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      isDisease!?"Your processed image with the detected disease shall appear hear":"Your processed image with the identified variety shall appear hear",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Time New Roman'
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),


                ),
                ...displayBoxesAroundRecognizedObjects(size),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Pick or Take an image",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Time New Roman'
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: !_processing? () {
                  setState(() {
                    imageFile = null;
                    _confidence = 0.0;
                    _disease = null;
                    _recommendation =null;
                    yoloResults = [];
                  });
                 imageDialog(context, true);
                }:null,
                child: Image.asset(
                  'assets/images/uploadIcon.png',
                  width: 50,
                  height: 50,
                ),
              ),
            ],
          ),
          Expanded(
            flex: 6,
            child: NestedScrollView(
              body:_processing
                  ? Align(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    CircularProgressIndicator(
                      value: _confidence,
                    ),
                    const Text(
                      'Processing...',
                      style: TextStyle(fontSize: 16.0),
                    )
                  ],
                ),
              )
                  : imageFile != null &&_disease != null?
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    labelColor: Colors.blue,
                    dividerColor: Colors.transparent,
                    tabAlignment: TabAlignment.start,
                    unselectedLabelColor: Colors.black,
                    onTap: (index){},
                    labelStyle: TextStyle(
                      fontSize: 20
                    ),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                    indicator: const ShapeDecoration(
                      shape: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue, // Set the color to transparent
                          width: 2,
                        ),
                      ),
                    ),
                    tabs: [
                      Text("Results"),
                      Text("Overview"),
                      isDisease!?Text("Causes"): Text("Benefits"),
                      isDisease!?Text("Prevention & Cure"): Text("Other Info"),

                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                        controller: _tabController,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  height: 100.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        "The Confidence of result is:",
                                        style: TextStyle(
                                            fontSize: 16, fontFamily: 'Time New Roman'),
                                      ),
                                      SizedBox(
                                        width: 70,
                                        height: 70,
                                        child: CustomPaint(
                                          painter: CircleProgressBar(
                                            percentage: _confidence,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                isDisease!?Text(
                                  'Disease: $_disease',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      fontFamily: 'Time New Roman'),
                                )
                                :Text(
                                  'Variety: $_disease',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      fontFamily: 'Time New Roman'),
                                ),

                                const SizedBox(height: 10.0),
                                Text('$_recommendation',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      fontFamily: 'Time New Roman'
                                  ),
                                ),

                                Row(
                                  children: [
                                    CircleAvatar(
                                      child: Image.file(
                                        imageFile!,
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Text(_disease!,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Time New Roman'),
                                    ),
                                  ],
                                ),
                                isDisease!? Text(
                                  "Groundnut leaf spot is a common fungal disease affecting groundnut (peanut) plants, caused by various pathogens such as Cercospora arachidicola and Cercosporidium personatum. It typically manifests as small, dark spots on the leaves, which can merge and cause extensive damage if not managed properly",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Time New Roman'),
                                )
                                :Text("Coming soon",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Time New Roman'),
                                ),
                                const SizedBox(height: 20.0),
                              ],
                            ),
                          ),
                              Center(
                          child: isDisease!
                              ? Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Early and late leaf spots',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Times New Roman'
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Early leaf spot (Cercospora. arachidicola) and late leaf spot (Phaeoisariopsis personatum) are the most damaging diseases of groundnuts worldwide. Besides adversely affecting the yield and quality of pod, they also affect the yield and quality of haulm. Although just one leaf spot pathogen usually predominates in a production region, both leaf spot species are generally found in a single field. Shifts in leaf spot species also have been observed over a period of years.\n\n'
                                          'Early leaf spot (Cercospora arachidicola Hori) develops small necrotic flecks, that usually have light to dark-brown centers, and a yellow halo. The spots may range from 1 mm - 10 mm in diameter. Sporulation is on the adaxial (upper) surface of leaflets.\n\n'
                                          'Late leaf spot (Phaeoisariopsis personata (Berk & Curt) develops small necrotic flecks that enlarge and become light to dark brown. The yellow halo is either absent or less conspicuous in late leaf spot. Sporulation is common on the abaxial (lower) surface of leaves. Farmers confuse leafspots with harvest indicators making mitigation measures difficult. The disease(s) maybe expressed on both the leaves and stems and this results in poor crop stand and yields.',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Times New Roman'
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Text("Variety Overview shall appear here"),
                        ),
                        Center(
                          child: isDisease!
                              ? Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Causes of Leaf Spot Disease',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Times New Roman'
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          '1. Fungal pathogens: Caused primarily by Cercospora arachidicola (early leaf spot) and Phaeoisariopsis personatum (late leaf spot) fungi.\n\n'
                                          '2. Environmental conditions: Warm temperatures (25-30°C) and high humidity favor fungal growth and spore production.\n\n'
                                          '3. Poor field sanitation: Infected crop residues left in the field serve as sources of inoculum.\n\n'
                                          '4. Continuous cropping: Growing groundnuts in the same field year after year increases pathogen buildup.\n\n'
                                          '5. Rain splash: Helps spread fungal spores from infected plants to healthy ones.\n\n'
                                          '6. Wind dispersal: Can carry fungal spores over long distances.\n\n'
                                          '7. Susceptible varieties: Planting non-resistant groundnut varieties increases disease incidence.',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Times New Roman'
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Text("Variety benefits shall appear here"),
                      ),
                      Center(
                        child: isDisease!
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Control Measures',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Times New Roman'
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Cultural Control:\n'
                                        '• Crop rotation has been shown to provide partial control of leaf spots. When groundnut followed either maize or pasture, the disease development was slow and less severe.\n'
                                        '• Early sowing has been shown to reduce the severity of leafspot diseases. Adjust the date of sowing to avoid conditions favourable for rapid disease development.\n'
                                        '• Burying all groundnut crop residues by deep plowing will reduce initial inoculum.\n\n'
                                        'Chemical control:\n'
                                        '• Multiple applications of a fungicide such as benomyl, captafol, chlorothalonil, copper hydroxide, mancozeb or sulphur fungicides may control early and late leaf spot.\n'
                                        '• Three sprays of 0.2% chlorothalonil at intervals of 10 - 15 days starting 40 days after germination up to 90 days provides effective control to early and late leaf spots, and rust.\n\n'
                                        'Host plant resistance:\n'
                                        '• Grow cultivars tolerant to late leaf spot: Sources of resistance to both early and late leaf spot have been identified in Arachis hypogaea and used to develop breeding lines with resistance e.g. ICGV 87160, ICGV 86590, ICGV-SM 95741, ICGV-SM 95714, Serenut 8R, Serenut 12R and Serenut 14R.',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Times New Roman'
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Text("Other information about variety shall appear here"),
                      )
                        ],
                      ),
                  ),


                ],
              )
              :const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'After selecting an image processing it your results will appear here',
                  style: TextStyle(
                      fontSize: 20, fontFamily: 'Time New Roman'),
                  textAlign: TextAlign.center,
                ),
              ), headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) { return []; },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        onPressed: _disease != null&& _confidence >0? () {
          // Display bottom sheet with recommendations
          _showRecommendations(context);
        }: null,
        child:
        _disease != null && _confidence >0?const Text('View Recommendations'): _disease != null && _confidence <0 ?const Text('No confidence in results'):const Text('No results yet'),
      ),
    );

  }

  Future<void> loadYoloModel() async {
    await vision.loadYoloModel(
        labels: _label!,
        modelPath: _model!,
        modelVersion: "yolov8",
        quantization: false,
        numThreads: 2,
        useGpu: false);
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Capture a photo
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        imageFile = File(photo.path);
      });
    }
  }



  yoloOnImage() async {
    setState(() {
      _processing = true;
    });

    yoloResults.clear();
    Uint8List byte = await imageFile!.readAsBytes();
    final image = await decodeImageFromList(byte);
    imageHeight = image.height;
    imageWidth = image.width;

    try {
      final result = await Future.delayed(Duration(seconds: 5), () {
        print("Model has started running");
        return vision.yoloOnImage(
          bytesList: byte,
          imageHeight: image.height,
          imageWidth: image.width,
          iouThreshold: 0.8,
          confThreshold: 0.4,
          classThreshold: 0.5,
        );
      });
      print("Model has completed running successfully");

      if (result.isNotEmpty) {
        setState(() {
          yoloResults = result;
          _processing = false;
        });
        _processResults(result);
      } else {
        setState(() {
          _processing = false;
        });
        // Handle case where No results obtained
        result.isEmpty?
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('No results obtained'),
            content: Text('Either your image is unclear or it is not groundnut leaf'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        ):showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delay'),
            content: Text('The model is taking too much time in processing'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        _processing = false;
      });
      // Handle timeout or other errors
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while processing the image.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }


  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];

    double factorX = screen.width / imageWidth;
    double imgRatio = imageWidth / imageHeight;
    double newWidth = imageWidth * factorX;
    double newHeight = newWidth / imgRatio;
    double factorY = newHeight / imageHeight;

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);
    return yoloResults.map((result) {
      double boxWidth = (result["box"][2] - result["box"][0]) * factorX * 0.8;
      double boxHeight = (result["box"][3] - result["box"][1]) * factorY * 0.8;

      // Calculate text width using TextPainter
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text:
          "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
          style: const TextStyle(fontSize: 18.0),
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      double textWidth = textPainter.size.width;

      if (textWidth > boxWidth) {
        // Increase box width if tag text doesn't fit
        boxWidth = textWidth + 20;
      }

      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY,
        width: boxWidth,
        height: boxHeight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                background: Paint()..color = colorPick,
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  void _processResults(List<dynamic> results) {
    // Assume results are in the format [disease, confidence]
    _disease = results[0]['tag'];
    _confidence = results[0]['box'][4];
    // Get recommendation based on the detected disease
    _recommendation = _getRecommendationForDisease(_disease);
  }

  String? _getRecommendationForDisease(String? disease) {
    // Implement your logic to provide recommendations for different diseases
    return "Recommendations for $_disease";
  }

  getImageDialog(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    final pickedImage = await picker.pickImage(
      source: source,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
        yoloOnImage();
      });
    }
  }

  void _showRecommendations(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Recommendations on $_disease:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(
                '1. Practice good field sanitation.\n'
                    '2. Use disease-resistant crop varieties.\n'
                    '3. Implement integrated pest management strategies.\n'
                    '4. Consult with agricultural experts for guidance.',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        );
      },
    );
  }

  void imageDialog(BuildContext context, bool image) {
    showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Media Source"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      if (image) {
                        getImageDialog(ImageSource.gallery);
                        Navigator.pop(context);
                      } else {}
                    },
                    icon: const Icon(Icons.image)),
                IconButton(
                    onPressed: () {
                      if (image) {
                        getImageDialog(ImageSource.camera);
                        Navigator.pop(context);
                      } else {}
                    },
                    icon: const Icon(Icons.camera_alt)),
              ],
            ),
          );
        },
        context: context);
  }
}




