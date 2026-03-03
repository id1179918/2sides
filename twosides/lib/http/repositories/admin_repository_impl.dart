import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:twosides/http/repositories/admin_repository.dart';
import 'package:twosides/http/two_sides_http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:twosides/models/auth.dart';


class AdminRepositoryImpl implements AdminRepository {
  final String baseUrl;

  AdminRepositoryImpl({
    String? baseUrl,
  }) : baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:3000';

  Future<Auth> login(String email, String password) async {
    try {
      var client = TwoSidesHttp();
      var uri = Uri.http(this.baseUrl, '/admin/login', null);

      var response = client.post(uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        })
      );

      return await client.handleResponse<Auth>(response, (json)=> Auth.fromJson(json));

    } catch (e) {
      rethrow;
    }
  }

  Future<Auth> logout() async {
    try {
      var client = TwoSidesHttp();
      var uri = Uri.http(this.baseUrl, '/admin/logout', null);

      var response = client.post(uri);

      return await client.handleResponse<Auth>(response, (json)=> Auth.fromJson(json));

    } catch (e) {
      rethrow;
    }
  }

  Future<Auth> adminCheck() async {
    try {
      var client = TwoSidesHttp();
      var uri = Uri.http(this.baseUrl, '/admin/me', null);

      var response = client.get(uri);

      return await client.handleResponse<Auth>(response, (json)=> Auth.fromJson(json));

    } catch (e) {
      rethrow;
    }
  }
}