import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:twosides/constants/env.dart';
import 'dart:developer';
import 'dart:io';
import 'package:twosides/models/artist.dart';
import 'package:twosides/http/repositories/link_repository.dart';
import 'package:twosides/http/two_sides_http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:twosides/models/asset.dart';
import 'package:twosides/models/link.dart';
import 'package:twosides/models/auth.dart';
import 'package:twosides/constants/routes.dart';

class LinkRepositoryImpl implements LinkRepository {
  final String baseUrl;

  LinkRepositoryImpl({
    String? baseUrl,
  }) : baseUrl = Env.baseUrl;

  @override
  Future<Auth> upsertLinkEntity(String linkType, String url, String label,
      String entityType, String entityId) async {
    try {
      var client = TwoSidesHttp();
      var uri = Uri.parse('${httpsHead}${baseUrl}/entity/link');

      var response = client.put(uri,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "linkType": linkType,
            "url": url,
            "label": label,
            "entityType": entityType,
            "entityId": entityId,
          }));

      return await client.handleResponse<Auth>(
          response, (json) => Auth.fromJson(json));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Auth> deleteLink(int linkId) async {
    try {
      var client = TwoSidesHttp();
      var uri = Uri.parse('${httpsHead}${baseUrl}/entity/link');

      var response = client.delete(uri,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "linkId": linkId,
          }));

      return await client.handleResponse<Auth>(
          response, (json) => Auth.fromJson(json));
    } catch (e) {
      rethrow;
    }
  }
}
