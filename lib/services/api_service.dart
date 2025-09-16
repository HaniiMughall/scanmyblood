import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  Future<String> predictOnline(File imageFile) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://YOUR_SERVER_IP:5000/predict'));
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));

    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    var data = jsonDecode(respStr);
    return data['blood_group'];
  }
}
