import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> callBloodGroupAPI(File imageFile) async {
  var bytes = await imageFile.readAsBytes();
  var base64Image = base64Encode(bytes);

  var response = await http.post(
    Uri.parse('https://example.com/predict'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"image": base64Image}),
  );

  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    return result['blood_group'];
  } else {
    throw Exception("API Error");
  }
}
