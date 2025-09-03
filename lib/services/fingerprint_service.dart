import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class FingerprintService {
  static const String baseUrl = "http://127.0.0.1:5000";
  // ⚠️ mobile testing ke liye "http://192.168.100.x:5000" use karna hoga
  // (same WiFi me Flask + mobile)

  static Future<String?> getBloodGroup(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/predict'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var decoded = jsonDecode(responseData);
        return decoded['blood_group'];
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
