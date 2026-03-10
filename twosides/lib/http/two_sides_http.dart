import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/browser_client.dart';
import 'package:path/path.dart';
import 'package:twosides/models/artist.dart';
import 'package:twosides/http/auth_manager.dart';
import 'package:twosides/models/api_error.dart';
import 'package:cross_file/cross_file.dart';

class InvalidCredentials implements Exception {
  InvalidCredentials();
}

class NoInternetException implements Exception {
  NoInternetException();
}

class TwoSidesHttp extends http.BaseClient {
  static String httpLocale = 'fr_FR';
  final http.Client _client = BrowserClient()..withCredentials = true;
  final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:3000';

  Future<http.Response> uploadPhoto(XFile photo) async {
    final Uri uri = Uri.https(this.baseUrl, "/asset", null);

    var request = http.MultipartRequest('POST', uri);

    var photoStream = http.ByteStream(photo.openRead());
    photoStream.cast();
    var length = await photo.length();

    var multipartFile = http.MultipartFile(
      'file',
      photoStream,
      length,
      filename: basename(photo.path),
    );

    request.files.add(multipartFile);

    http.StreamedResponse streamedResponse = await send(request);

    return http.Response.fromStream(streamedResponse);
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    try {
      if (request is http.Request) {
        if (request.body.isNotEmpty) {
          request.headers.addAll({"Content-Type": "application/json"});
          request.headers.addAll({"Credentials": "true"});
        }
      }

      log("##HTTP : ${request.method} ${request.url}");
      request.headers['credentials'] = 'include';

      return await _client.send(request).timeout(const Duration(seconds: 20),
          onTimeout: () {
        throw TimeoutException("Timeout");
      });
    } catch (e) {
      if (e is SocketException || e is TimeoutException) {
        throw NoInternetException();
      }
      rethrow;
    }
  }

  Future<dynamic> _handleErrorResponse(http.Response response) async {
    if (response.statusCode >= 400 && response.statusCode < 600) {
      try {
        final error = errorFromJson(response.body);
        if (error.key == "Invalid credentials") {
          throw InvalidCredentials();
        }
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<T> handleResponse<T>(Future<http.Response> futureResponse,
      T Function(dynamic) onSuccess) async {
    final response = await futureResponse;

    await _handleErrorResponse(response);

    try {
      final dynamic decoded = jsonDecode(response.body);
      return onSuccess(decoded[0]);
    } catch (error) {
      rethrow;
    } finally {
      close();
    }
  }

  Future<List<T>> handleListResponse<T>(Future<http.Response> futureResponse,
      T Function(Map<String, dynamic>) onSuccess) async {
    final response = await futureResponse;

    await _handleErrorResponse(response);

    try {
      log('RAW BODY: ${response.body}');
      log('STATUS: ${response.statusCode}');

      final List<dynamic> decodedList = jsonDecode(response.body);
      return decodedList
          .map((jsonItem) => onSuccess(jsonItem as Map<String, dynamic>))
          .toList();
    } catch (error) {
      rethrow;
    } finally {
      close();
    }
  }
}
