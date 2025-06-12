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
                                :SizedBox(),

                                const SizedBox(height: 20.0),
                              ],
                            ),
                          ),

                        //  Disease Overview Section
                                                    
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
                                            'Early leaf spot (Cercospora. arachidicola) and late leaf spot (Phaeoisariopsis personatum) are the most damaging diseases of groundnuts worldwide. Besides adversely affecting the yield and quality of pod, they also affect the yield and quality of haulm.\n\n'
                                            'Resistant varieties include:\n'
                                            '- ICGV 87160\n'
                                            '- ICGV 86590\n'
                                            '- ICGV-SM 95741\n'
                                            '- ICGV-SM 95714\n'
                                            '- Serenut 8R\n'
                                            '- Serenut 12R\n'
                                            '- Serenut 14R\n\n'
                                            'These varieties have shown tolerance to both early and late leaf spot diseases and are recommended for cultivation in affected areas.',
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
                                : Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Text(
                                            'Recommended Groundnut Varieties for Uganda',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Times New Roman'
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Uganda has developed several high-yielding groundnut varieties through the National Groundnut Improvement Programme:\n\n'
                                            '1. Serenut 1R (Virginia, tan) - 100-110 days maturity, 2500-3700 kg/ha yield\n'
                                            '2. Serenut 2 (Virginia, red) - 100-110 days, 2500-3700 kg/ha\n'
                                            '3. Serenut 3R (Spanish, red) - 90-100 days, 2500-2900 kg/ha\n'
                                            '4. Serenut 4T (Spanish, tan) - 90-100 days, 2500-2900 kg/ha\n'
                                            '5. Serenut 5R (Virginia, red) - 100-110 days, 2500-3000 kg/ha\n'
                                            '6. Serenut 6T (Spanish, tan) - 90-100 days, 2500-3000 kg/ha\n'
                                            '7. Serenut 7T (Virginia, tan) - 100-110 days, 2500-3700 kg/ha\n'
                                            '8. Serenut 8R (Virginia, red) - 100-110 days, 2500-3700 kg/ha\n'
                                            '9. Serenut 9T (Virginia, tan) - 100-110 days, 2500-3700 kg/ha\n'
                                            '10. Serenut 10R (Virginia, red) - 100-110 days, 2500-3700 kg/ha\n'
                                            '11. Serenut 11T (Virginia, tan) - 100-110 days, 2500-3700 kg/ha\n'
                                            '12. Serenut 12R (Virginia, red) - 100-110 days, 2500-3700 kg/ha\n'
                                            '13. Serenut 13T (Virginia, tan) - 100-110 days, 2500-3700 kg/ha\n'
                                            '14. Serenut 14R (Virginia, red) - 100-110 days, 2500-3700 kg/ha\n\n'
                                            'These varieties are suitable for different market uses including confectionery, butter, oil, and flour production.',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Times New Roman'
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),


                  // Disease Causes Section

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
                                        '3. Continuous cropping: Growing groundnuts in the same field year after year increases pathogen buildup.\n\n'
                                        '4. Poor field sanitation: Infected crop residues left in the field serve as sources of inoculum.\n\n'
                                        '5. Susceptible varieties: Planting non-resistant groundnut varieties increases disease incidence.\n\n'
                                        '6. Rain splash: Helps spread fungal spores from infected plants to healthy ones.\n\n'
                                        '7. Wind dispersal: Can carry fungal spores over long distances.',
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
                            : Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Benefits of Improved Groundnut Varieties',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Times New Roman'
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'The improved groundnut varieties offer several benefits:\n\n'
                                        '1. High yields: Most varieties yield between 2500-3700 kg/ha compared to traditional varieties\n'
                                        '2. Disease resistance: Many varieties are resistant to major diseases like rosette and leaf spots\n'
                                        '3. Drought tolerance: Varieties like Serenut 8R have "stay-green" traits for drought tolerance\n'
                                        '4. Early maturity: Some varieties mature in 90-100 days enabling double cropping\n'
                                        '5. Market preferences: Available in different colors (red, tan) to suit regional preferences\n'
                                        '6. Multiple uses: Suitable for confectionery, oil extraction, butter, and flour production\n'
                                        '7. Improved quality: Higher oil content and better nutritional value\n'
                                        '8. Adaptability: Suitable for different agro-ecological zones in Uganda',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Times New Roman'
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),


             // Disease Prevention & Cure Section

                  Center(
                    child: isDisease!
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    'Control Measures for Leaf Spot',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Times New Roman'
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Cultural Control:\n'
                                    '• Crop rotation with cereals or pasture reduces disease incidence\n'
                                    '• Early sowing helps avoid peak disease periods\n'
                                    '• Deep plowing to bury crop residues reduces initial inoculum\n\n'
                                    'Chemical Control:\n'
                                    '• Three sprays of 0.2% chlorothalonil at 10-15 day intervals starting 40 days after germination\n'
                                    '• Carbendazim (0.05%) is effective against both leaf spots\n'
                                    '• Fungicides like benomyl, captafol, copper hydroxide, mancozeb or sulphur can be used\n\n'
                                    'Host Plant Resistance:\n'
                                    '• Grow resistant varieties like:\n'
                                    '  - ICGV 87160\n'
                                    '  - ICGV 86590\n'
                                    '  - ICGV-SM 95741\n'
                                    '  - ICGV-SM 95714\n'
                                    '  - Serenut 8R\n'
                                    '  - Serenut 12R\n'
                                    '  - Serenut 14R\n\n'
                                    'These varieties have shown good tolerance to leaf spot diseases.',
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
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    'Additional Variety Information',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Times New Roman'
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Key characteristics of Ugandan groundnut varieties:\n\n'
                                    '1. Growth Habit:\n'
                                    '   - Bunch types: Serenut 3R, 4T, 5R, 6T (spacing 45cm x 7.5-10cm)\n'
                                    '   - Semi-erect types: Serenut 1R, 2, 7T, 8R, 9T, 10R, 11T, 12R, 13T, 14R (spacing 45cm x 10-15cm)\n\n'
                                    '2. Maturity Groups:\n'
                                    '   - Early (85-90 days): Acholi White, Red Beauty\n'
                                    '   - Medium (90-100 days): Serenut 3R, 4T, 6T\n'
                                    '   - Late (100-110 days): Most Serenut varieties\n\n'
                                    '3. Special Traits:\n'
                                    '   - Drought tolerance: Serenut 8R has "stay-green" trait\n'
                                    '   - Disease resistance: Most Serenut varieties resistant to rosette\n'
                                    '   - Pest tolerance: Serenut 10R shows tolerance to leafminer\n\n'
                                    '4. Regional Preferences:\n'
                                    '   - Northern/Eastern Uganda prefer tan/white varieties\n'
                                    '   - Western/Central/Southern prefer red varieties\n\n'
                                    '5. Seed Sources:\n'
                                    '   - Available from NARO/NaSARRI Serere\n'
                                    '   - Certified seed companies\n'
                                    '   - Select trained farmers',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Times New Roman'
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ),
                          ),
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




