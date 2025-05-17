import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OnlinePaymentInfo {
  final String baseUrl;
  final String secretKey;

  // Constructor
  OnlinePaymentInfo({required this.baseUrl, required this.secretKey});

  Future<http.Response> post({
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      debugPrint('Error with http post method: ${e.toString()}');
      final response = http.Response(
        jsonEncode({
          'error': 'An error occurred while processing your request.',
          'details': e.toString(),
        }),
        500,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      return response;
    }
  }

  Future<http.Response> get({
    required String endpoint,
    Map<String, String>? queryParams,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/json',
        },
      );
      return response;
    } catch (e) {
      debugPrint('Error with http get method: ${e.toString()}');
      final response = http.Response(
        jsonEncode({
          'error': 'An error occurred while processing your request.',
          'details': e.toString(),
        }),
        500,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      return response;
    }
  }
}
