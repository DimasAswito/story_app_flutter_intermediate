import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:story_app_flutter_intermediate/data/model/story.dart';

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> addNewStory(
      String token, String description, List<int> bytes, String fileName) async {
    var uri = Uri.parse('$_baseUrl/stories');
    var request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['description'] = description;

    var multipartFile = http.MultipartFile.fromBytes(
      'photo',
      bytes,
      filename: fileName,
    );
    request.files.add(multipartFile);

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    return jsonDecode(responseBody);
  }

  Future<Map<String, dynamic>> getAllStories(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/stories'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getDetailStory(String token, String id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/stories/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    return jsonDecode(response.body);
  }
}
