import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

import '../../theme/custom_theme.dart';
import '../../utils/circular_progress.dart';

class LeafSpotDetectionScreen extends StatefulWidget {
  const LeafSpotDetectionScreen({super.key});

  @override
  State<LeafSpotDetectionScreen> createState() => _LeafSpotDetectionScreenState();
}

class _LeafSpotDetectionScreenState extends State<LeafSpotDetectionScreen> {
  File? selectedImage;
  bool _processing = false;
  double _processingPercentage = 0.0;
  String? _disease;
  double _confidence =0.0;
  String? _recommendation;



  Future<void> _processUploadedImage() async {
    if (selectedImage == null) {
      // Show error message or prompt user to upload an image
      return;
    }

    setState(() {
      _processing = true;
    });
    print("Processing");
    try {
      await Tflite.loadModel(
        model: 'assets/ai_model/leafspot_Naro.tflite',
        labels: 'assets/ai_model/labels.txt',
      );
      final List<dynamic>? results = await Tflite.runModelOnImage(
        path: selectedImage!.path,
        imageMean: 0.0,   // defaults to 117.0
        imageStd: 255.0,  // defaults to 1.0
        numResults: 2,    // defaults to 5
        threshold: 0.2,   // defaults to 0.1
        asynch: true
      );
      print("Processing ended");
      setState(() {
        _processing = false;
        _processResults(results!);
      });
    } catch (e) {
      print("Error processing image: $e");
      // Handle the error, show a message to the user, etc.
    } finally {
      // Dispose of the TensorFlow Lite interpreter
      await Tflite.close();
      setState(() {
        _processing = false;
      });
    }

    setState(() {
      _processing = false;
    });
  }


  void _processResults(List<dynamic> results) {
    // Assume results are in the format [disease, confidence]
    _disease = results[0]['label'];
    _confidence = results[0]['confidence'];
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
        selectedImage = File(pickedImage.path);
        _processUploadedImage(); // Move this inside the if block
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: CustomTheme.primary,
        title: FxText.titleLarge(
          'NARO AI VISION',
          color: Colors.white,
          fontWeight: 900,
        ),
      ),
      body: Column(
        children: [
          Align(
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.width* 0.8,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: (selectedImage != null)
                      ? DecorationImage(
                    image: FileImage(selectedImage!),
                    fit: BoxFit.cover,
                  )
                      : null,
                  color: selectedImage == null? Color(0xffC4C4C4).withOpacity(0.2): Colors.transparent,
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Container(
                    width: 76,
                    height: 59,
                    child: Image.asset('assets/images/uploadIcon.png'),
                  ),
                  Text(
                     'Click and upload image',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        _processing? null:
                        imageDialog(context, true);
                      },
                    child: Text('Upload'),
                  ),
      
      
                ],
              ),
      
            ),
      
          ),
          Expanded(
            child: SingleChildScrollView(
              child:  _processing?
              Align(
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
              ): Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    height: 100.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("The percentage of disease is:"),
                        Container(
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
                  SizedBox(height: 20.0),
                  _disease != null && _confidence != null
                      ? Column(
                    children: [
                      Text('Disease: $_disease'),
                      Text('Confidence: ${(_confidence! * 100).toStringAsFixed(2)}%'),
                      SizedBox(height: 10.0),
                      Text('Recommendation: $_recommendation'),
                    ],
                  )
                      : Container(),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        selectedImage != null
                            ? Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    child: Image.file(
                                      selectedImage!,
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
      
                                  const Text("Cercospora arachidicola"),
                                  const Text("Leaf Spot")
                                ],
                              ),
                              const Text("Groundnut leaf spot is a common fungal disease affecting groundnut (peanut) plants, caused by various pathogens such as Cercospora arachidicola and Cercosporidium personatum. It typically manifests as small, dark spots on the leaves, which can merge and cause extensive damage if not managed properly"),
                              ElevatedButton(
                                onPressed: () {
                                  // Display bottom sheet with recommendations
                                  _showRecommendations(context);
                                },
                                child: const Text('View Recommendations'),
                              ),
                            ],
                          ),
                        )
                            : const Text('No image selected'),
                        const SizedBox(height: 10.0),
      
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRecommendations(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Disease Recommendations:',
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
                      } else {

                      }
                    },
                    icon: const Icon(Icons.image)),
                IconButton(
                    onPressed: () {
                      if (image) {
                        getImageDialog(ImageSource.camera);
                        Navigator.pop(context);
                      } else {

                      }
                    },
                    icon: const Icon(Icons.camera_alt)),
              ],
            ),
          );
        },
        context: context);
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

}




