import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkHelper {
  final url;

  NetworkHelper({required this.url});

  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
      return null;
    }
  }
}
