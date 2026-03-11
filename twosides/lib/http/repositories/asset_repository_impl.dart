import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:twosides/constants/env.dart';
import 'dart:developer';
import 'dart:io';
import 'package:twosides/models/artist.dart';
import 'package:twosides/http/repositories/asset_repository.dart';
import 'package:twosides/http/two_sides_http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:twosides/models/asset.dart';
import 'package:twosides/models/link.dart';
import 'package:twosides/models/auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cross_file/cross_file.dart';
import 'package:twosides/constants/routes.dart';

class AssetRepositoryImpl implements AssetRepository {
  final String baseUrl;

  AssetRepositoryImpl({
    String? baseUrl,
  }) : baseUrl = Env.baseUrl;

  @override
  Future<int> uploadAsset(XFile file) async {
    try {
      var client = TwoSidesHttp();

      var response = client.uploadPhoto(file);

      return await client.handleResponse<int>(response, (json) => json['id']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Auth> assignAssetArtist(int assetId, int artistId, String role) async {
    try {
      var client = TwoSidesHttp();
      var uri = Uri.parse('${httpsHead}${baseUrl}/entity/asset');

      log("{entityType: 'artist', entityId: ${artistId}, assetId: ${assetId}, role: ${role}}");

      var response = client.post(uri,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "entityType": "artist",
            "entityId": artistId.toString(),
            "assetId": assetId.toString(),
            "role": role,
          }));

      return await client.handleResponse<Auth>(
          response, (json) => Auth.fromJson(json));
    } catch (e) {
      rethrow;
    }
  }

  Future<Auth> upsertAssetArtist(int artistId, String role) async {
    try {
      var client = TwoSidesHttp();
      var uri = Uri.parse('${httpsHead}${baseUrl}/asset');

      //log("{entityType: 'artist', entityId: ${artistId}, assetId: ${assetId}, role: ${role}}");

      var response = client.put(uri,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "entityType": "artist",
            "entityId": artistId.toString(),
            "role": role,
          }));

      return await client.handleResponse<Auth>(
          response, (json) => Auth.fromJson(json));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Auth> deleteAsset(int assetId) async {
    try {
      var client = TwoSidesHttp();
      var uri = Uri.parse('${httpsHead}${baseUrl}/asset');

      var response = client.delete(uri,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "assetId": assetId.toString(),
          }));

      return await client.handleResponse<Auth>(
          response, (json) => Auth.fromJson(json));
    } catch (e) {
      rethrow;
    }
  }
}
