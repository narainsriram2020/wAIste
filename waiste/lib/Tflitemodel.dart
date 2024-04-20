import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

void main() {
  runApp(const TfliteModel());
}

class TfliteModel extends StatefulWidget {
  const TfliteModel({super.key});

  @override
  State<TfliteModel> createState() => _TfliteModelState();
}

class _TfliteModelState extends State<TfliteModel> {
  get model => null;


  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    Tflite.close();
    Tflite.close();
    String? res;
    res = await Tflite.loadModel(model: model);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}