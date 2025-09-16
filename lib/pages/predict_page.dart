import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/prediction_service.dart';

class PredictPage extends StatefulWidget {
  const PredictPage({super.key});

  @override
  _PredictPageState createState() => _PredictPageState();
}

class _PredictPageState extends State<PredictPage> {
  File? _image;
  String _prediction = '';
  final picker = ImagePicker();
  final PredictionService _predictionService = PredictionService();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
      String result = await _predictionService.getPrediction(_image!);
      setState(() => _prediction = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blood Group Prediction')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? const Text('No image selected')
                : Image.file(_image!),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: pickImage, child: const Text('Pick Image')),
            const SizedBox(height: 20),
            Text('Prediction: $_prediction',
                style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
