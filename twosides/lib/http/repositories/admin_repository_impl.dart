import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:twosides/http/repositories/admin_repository.dart';
import 'package:twosides/http/two_sides_http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:twosides/models/auth.dart';
import 'package:twosides/constants/routes.dart';

class AdminRepositoryImpl implements AdminRepository {
  final String baseUrl;

  AdminRepositoryImpl({
    String? baseUrl,
  }) : baseUrl = dotenv.env['BASE_URL'] ?? 'https://2sides-agency.fr/api';

  Future<Auth> login(String email, String password) async {
    try {
      var client = TwoSidesHttp();
      var uri = Uri.parse('${httpsHead}${baseUrl}/admin/login');

      var response = client.post(uri,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': email,
            'password': password,
          }));

      return await client.handleResponse<Auth>(
          response, (json) => Auth.fromJson(json));
    } catch (e) {
      rethrow;
    }
  }

  Future<Auth> logout() async {
    try {
      var client = TwoSidesHttp();
      var uri = Uri.parse('${httpsHead}${baseUrl}/admin/logout');

      var response = client.post(uri);

      return await client.handleResponse<Auth>(
          response, (json) => Auth.fromJson(json));
    } catch (e) {
      rethrow;
    }
  }

  Future<Auth> adminCheck() async {
    try {
      var client = TwoSidesHttp();
      var uri = Uri.parse(
        '${httpsHead}${baseUrl}/admin/me',
      );

      var response = client.get(uri);

      return await client.handleResponse<Auth>(
          response, (json) => Auth.fromJson(json));
    } catch (e) {
      rethrow;
    }
  }
}
