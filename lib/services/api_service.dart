import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:5000'; // placeholder backend

  // Existing functions
  static Future<bool> uploadDonor(Map<String, dynamic> donor) async {
    try {
      final res = await http.post(Uri.parse('$baseUrl/donors'),
          body: jsonEncode(donor),
          headers: {
            'Content-Type': 'application/json'
          }).timeout(const Duration(seconds: 10));
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> uploadRequest(Map<String, dynamic> request) async {
    try {
      final res = await http.post(Uri.parse('$baseUrl/requests'),
          body: jsonEncode(request),
          headers: {
            'Content-Type': 'application/json'
          }).timeout(const Duration(seconds: 10));
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // New function for Blood Group Prediction (Online)
  static Future<String?> predictBloodGroup(File imageFile) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/predict'));
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));

      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var data = jsonDecode(respStr);

      return data['blood_group']; // backend should return {'blood_group': 'A+'}
    } catch (e) {
      print('Error in prediction API: $e');
      return null;
    }
  }
}
