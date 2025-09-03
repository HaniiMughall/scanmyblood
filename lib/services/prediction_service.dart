import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'api_service.dart';
import 'tflite_service.dart';
import 'package:scanmyblood/utils/bloodgroup_helper.dart';

class PredictionService {
  final TFLiteService tfliteService = TFLiteService();
  final ApiService apiService = ApiService();

  Future<String> _predictOffline(File imageFile) async {
    var result = await tfliteService.predict(imageFile);
    int predictedIndex = result.indexOf(result.reduce((a, b) => a > b ? a : b));
    return bloodGroupFromIndex(predictedIndex);
  }

  Future<String> getPrediction(File imageFile) async {
    var connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      try {
        var result = await ApiService.predictBloodGroup(imageFile);
        return result ?? await _predictOffline(imageFile);
      } catch (e) {
        return await _predictOffline(imageFile);
      }
    } else {
      return await _predictOffline(imageFile);
    }
  }
}
