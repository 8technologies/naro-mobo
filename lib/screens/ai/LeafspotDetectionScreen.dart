import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme/custom_theme.dart';
import '../../utils/circular_progress.dart';
class LeafSpotDetectionScreen extends StatefulWidget {

  const LeafSpotDetectionScreen({Key? key,}) : super(key: key);

  @override
  State<LeafSpotDetectionScreen> createState() => _LeafSpotDetectionScreenState();
}

class _LeafSpotDetectionScreenState extends State<LeafSpotDetectionScreen> {
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

  @override
  void initState() {
    super.initState();
    loadYoloModel().then((value) {
      setState(() {
        isLoaded = true;
      });
    });
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
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              fit: StackFit.loose,
              children: [
                imageFile != null ? Image.file(imageFile!)
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
                    child: const Text(
                      "Your processed image with the detected disease shall appear hear",
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
            child: SingleChildScrollView(
              child: _processing
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
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_disease != null) SizedBox(
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
                  ) else const SizedBox(height: 0,),
                  const SizedBox(height: 20.0),
                  _disease != null
                      ? Column(
                    children: [
                      Text(
                        'Disease: $_disease',
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
                    ],
                  )
                      : Container(),
                  const SizedBox(height: 20.0),
                  imageFile != null && _disease != null
                      ? Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            const Text("Cercospora arachidicola Leaf Spot",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Time New Roman'),
                            ),
                          ],
                        ),
                        const Text(
                          "Groundnut leaf spot is a common fungal disease affecting groundnut (peanut) plants, caused by various pathogens such as Cercospora arachidicola and Cercosporidium personatum. It typically manifests as small, dark spots on the leaves, which can merge and cause extensive damage if not managed properly",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Time New Roman'),
                        ),
                      ],
                    ),
                  )
                      : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'After selecting an image processing it your results will appear here',
                      style: TextStyle(
                          fontSize: 20, fontFamily: 'Time New Roman'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
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
        labels: 'assets/aimodel/labels.txt',
        modelPath: 'assets/aimodel/best_float32.tflite',
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




