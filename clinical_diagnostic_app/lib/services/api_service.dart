import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/diagnosis.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.16.103:3000/api';
  
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> register(String email, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<List<Diagnosis>> getDiagnosis(List<String> symptoms, String? specialty) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/diagnosis/diagnose'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'symptoms': symptoms,
          'specialty': specialty,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> diagnosesJson = data['diagnoses'] ?? [];
        return diagnosesJson.map((json) => Diagnosis.fromJson(json)).toList();
      } else {
        throw Exception('Diagnosis failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<bool> generateReport(Map<String, dynamic> reportData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reports/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reportData),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> emailReport(String email, Map<String, dynamic> reportData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reports/email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'reportData': reportData,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}