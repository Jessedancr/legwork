import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final String baseUrl = dotenv.env['NODE_API_BASE_URL']!;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

// * Post method
  Future<http.Response> post({
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    try {
      // final token = await storage.read(key: 'jwtToken');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwtToken');
      final userId = prefs.getString('userId');

      if (token == null || userId == null) {
        debugPrint('Token or user ID is null');
        final response = http.Response(
          'Unauthorised, no token or user ID found',
          500,
          headers: {'Content-Type': 'application/json'},
        );
        return response;
      }

      debugPrint('Token found: $token');
      debugPrint('User ID: $userId');

      final url = Uri.parse('$baseUrl/$endpoint');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      debugPrint('POST error: ${e.toString()}');
      final response = http.Response(
        jsonEncode({
          'error': 'An error occured while processing your request',
          'details': e.toString(),
        }),
        500,
        headers: {'Content-Type': 'application/json'},
      );
      return response;
    }
  }

// * Auth post
  Future<http.Response> authPost({
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      debugPrint('AUTH POST error: ${e.toString()}');
      final response = http.Response(
        jsonEncode({
          'error': 'An error occured while processing your request',
          'details': e.toString(),
        }),
        500,
        headers: {'Content-Type': 'application/json'},
      );
      return response;
    }
  }

// * Get method
  Future<http.Response> get({
    required String endpoint,
  }) async {
    try {
      // final token = await storage.read(key: 'jwtToken');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwtToken');

      final url = Uri.parse('$baseUrl/$endpoint');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      return response;
    } catch (e) {
      debugPrint('GET error: ${e.toString()}');
      final response = http.Response(
        jsonEncode({
          'error': 'An unknown error occured processing your request',
          'details': e.toString(),
        }),
        500,
        headers: {'Content-Type': 'application/json'},
      );
      return response;
    }
  }

// * PATCH method
  Future<http.Response> patch({
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    try {
      // final token = await storage.read(key: 'jwtToken');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final token = prefs.getString('jwtToken');
      if (token == null || userId == null) {
        debugPrint('Token or user ID null');
        final response = http.Response(
          'Unauthorised, no token or userId found',
          401,
          headers: {'Content-Type': 'application/json'},
        );
        return response;
      }
      debugPrint('Token found: $token');
      debugPrint('User ID: $userId');

      final url = Uri.parse('$baseUrl/$endpoint');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      debugPrint('PATCH error: ${e.toString()}');
      final response = http.Response(
        jsonEncode({
          'error': 'An error occured while processing your request',
          'details': e.toString()
        }),
        500,
        headers: {'Content-Type': 'application/json'},
      );
      return response;
    }
  }
}
