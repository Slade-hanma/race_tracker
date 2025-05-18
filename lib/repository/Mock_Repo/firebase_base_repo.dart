// lib/data/firebase_base_repo.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class FirebaseBaseRepo {
  static const String baseUrl = 'https://race-tracking-app-c2e54-default-rtdb.asia-southeast1.firebasedatabase.app/';

  Future<http.Response> get(String path) {
    return http.get(Uri.parse('$baseUrl/$path.json'));  // .json should only be appended here
  }

  Future<http.Response> post(String path, Map<String, dynamic> data) {
    return http.post(Uri.parse('$baseUrl/$path.json'), body: json.encode(data));  // Again, append .json here
  }

  Future<http.Response> put(String path, Map<String, dynamic> data) {
    return http.put(Uri.parse('$baseUrl/$path.json'), body: jsonEncode(data));
  }

  Future<http.Response> delete(String path) {
    return http.delete(Uri.parse('$baseUrl/$path.json'));
  }
}
