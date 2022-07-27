import 'package:flutter/material.dart';
import 'package:image_labeling/widgets/Watcher.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Watcher(),
      ),
    );
  }
}
