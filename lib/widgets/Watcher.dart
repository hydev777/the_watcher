
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Watcher extends StatefulWidget {
  const Watcher({Key? key}) : super(key: key);

  @override
  State<Watcher> createState() => _WatcherState();
}

class _WatcherState extends State<Watcher> {
  final String assetName = 'assets/images/watch_eye.svg';
  Widget? svg;

  Future<String> getModel(String assetPath) async {
    if (io.Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await io.Directory(dirname(path)).create(recursive: true);
    final file = io.File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  void getImage(BuildContext ctx) {
    svg = SvgPicture.asset(
      assetName,
      semanticsLabel: 'Eye',
      height: 35,
    );
    final ImagePicker _picker = ImagePicker();
    // final inputImage;

    showDialog(
        context: ctx,
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

                        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

                        final inputImage = InputImage.fromFilePath(image!.path);

                        final modelPath = await getModel('assets/ml/object_labeler.tflite');
                        final options = LocalLabelerOptions(modelPath: modelPath);
                        final imageLabeler = ImageLabeler(options: options);

                        final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
                        await imageLabeler.close();

                        for (ImageLabel label in labels) {
                          final String text = label.label;
                          final int index = label.index;
                          final double confidence = label.confidence;
                          print({ "-----------------", text, index, confidence });
                        }

                      },
                      icon: const Icon(Icons.photo, color: Colors.redAccent),
                      label: const Text(
                        'Choose image...',
                        style: TextStyle(fontSize: 18, color: Colors.redAccent),
                      )),
                  TextButton.icon(
                      onPressed: () async {
                        final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

                        final inputImage = InputImage.fromFilePath(photo!.path);

                        final modelPath = await getModel('assets/ml/object_labeler.tflite');
                        final options = LocalLabelerOptions(modelPath: modelPath);
                        final imageLabeler = ImageLabeler(options: options);

                        final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
                        await imageLabeler.close();

                        for (ImageLabel label in labels) {
                          final String text = label.label;
                          final int index = label.index;
                          final double confidence = label.confidence;
                          print({ "-----------------", text, index, confidence });
                        }

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
          getImage(context);
        },
        child: const Text(
          'I wanna see...',
          style: TextStyle(fontSize: 18),
        ));
  }
}
