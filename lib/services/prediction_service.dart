import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'api_service.dart';
import 'tflite_service.dart';
import 'package:scanmyblood/utils/bloodgroup_helper.dart';

class PredictionService {
  final TFLiteService tfliteService = TFLiteService();
  final ApiService apiService = ApiService();

  Future<String> getPrediction(File imageFile) async {
    var connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      try {
        return await apiService.predictOnline(imageFile);
      } catch (e) {
        return _predictOffline(imageFile);
      }
    } else {
      return _predictOffline(imageFile);
    }
  }

  String _predictOffline(File imageFile) {
    var result = tfliteService.predict(imageFile);
    int predictedIndex = result.indexOf(result.reduce((a, b) => a > b ? a : b));
    return bloodGroupFromIndex(predictedIndex);
  }
}
