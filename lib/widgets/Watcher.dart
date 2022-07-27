import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:provider/provider.dart';

import '../provider/image_detection_logic.dart';

class Watcher extends StatefulWidget {
  const Watcher({Key? key}) : super(key: key);

  @override
  State<Watcher> createState() => _WatcherState();
}

class _WatcherState extends State<Watcher> {
  void getImage() {
    final imageDetectionActions = Provider.of<ImageDetectionProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 100,
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    await imageDetectionActions.processImage(TypeOfInfo.image).whenComplete(() {
                      Future.delayed(Duration.zero, () {
                        Navigator.of(context).pop();
                      });
                    });
                  },
                  icon: const Icon(Icons.photo, color: Colors.redAccent),
                  label: const Text(
                    'Choose image...',
                    style: TextStyle(fontSize: 18, color: Colors.redAccent),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await imageDetectionActions.processImage(TypeOfInfo.photo).whenComplete(() {
                      Future.delayed(Duration.zero, () {
                        Navigator.of(context).pop();
                      });
                    });
                  },
                  icon: const Icon(Icons.camera_alt, color: Colors.redAccent),
                  label: const Text(
                    'Take a picture',
                    style: TextStyle(fontSize: 18, color: Colors.redAccent),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  final colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    bool showImage = Provider.of<ImageDetectionProvider>(context).showImage;
    Image image = Provider.of<ImageDetectionProvider>(context).image ?? Image.asset('');
    List<ImageLabel> informationExtracted = Provider.of<ImageDetectionProvider>(context).informationExtracted;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(seconds: 1),
              alignment: showImage ? Alignment.topCenter : Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: !showImage
                    ? TextButton(
                        onPressed: () {
                          getImage();
                        },
                        child: const Text(
                          'I wanna see...',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      )
                    : Column(
                        children: [
                          AnimatedTextKit(
                            repeatForever: true,
                            pause: const Duration(milliseconds: 500),
                            animatedTexts: [
                              ColorizeAnimatedText(
                                'This is what I see',
                                textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                colors: colorizeColors,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          image,
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView(
                              children: informationExtracted.map((information) {

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Label: ${information.label}", style: const TextStyle(color: Colors.black, fontSize: 18)),
                                      const SizedBox(width: 5),
                                      Text("Confidence: ${information.confidence.toString()} ", style: const TextStyle(color: Colors.black, fontSize: 18))
                                    ],
                                  ),
                                );

                              }).toList(),
                            ),
                          )
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
