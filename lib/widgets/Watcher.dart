
import 'package:flutter/material.dart';
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

                        imageDetectionActions.processImage(TypeOfInfo.image);

                      },
                      icon: const Icon(Icons.photo, color: Colors.redAccent),
                      label: const Text(
                        'Choose image...',
                        style: TextStyle(fontSize: 18, color: Colors.redAccent),
                      )),
                  TextButton.icon(
                      onPressed: () async {

                        imageDetectionActions.processImage(TypeOfInfo.photo);

                      },
                      icon: const Icon(Icons.camera_alt, color: Colors.redAccent),
                      label: const Text(
                        'Take a picture',
                        style: TextStyle(fontSize: 18, color: Colors.redAccent),
                      ))
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          getImage();
        },
        child: const Text(
          'I wanna see...',
          style: TextStyle(fontSize: 18),
        ));
  }
}
