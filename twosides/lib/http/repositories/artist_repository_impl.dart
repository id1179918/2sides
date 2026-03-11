import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:twosides/constants/env.dart';
import 'package:twosides/constants/routes.dart';
import 'dart:developer';
import 'package:twosides/models/artist.dart';
import 'package:twosides/http/repositories/artist_repository.dart';
import 'package:twosides/http/two_sides_http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:twosides/models/asset.dart';
import 'package:twosides/models/link.dart';
import 'package:twosides/models/auth.dart';

class ArtistRepositoryImpl implements ArtistRepository {
  final String baseUrl;

  ArtistRepositoryImpl({
    String? baseUrl,
  }) : baseUrl = Env.baseUrl;

  @override
  Future<Artist> getArtistByName(String name) async {
    try {
      var client = TwoSidesHttp();
      var uri = Uri.parse('${httpsHead}${baseUrl}/artist/name');

      var response = client.get(uri);

      return await client.handleResponse<Artist>(
          response, (json) => Artist.fromJson(json));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Artist>> getAllArtists() async {
    try {
      log('1. Creating client');
      var client = TwoSidesHttp();
      log('2. Create URI');
      var uri = Uri.parse('${httpsHead}${baseUrl}/artists');

      log('3. Create Rsp');
      var response = client.get(uri);

      log('2. Return Await');
      return await client.handleListResponse<Artist>(
          response, (json) => Artist.fromJson(json));
    } catch (e) {
      log("Error API: " + e.toString());
      rethrow;
    }
  }

  @override
  Future<Artist> getArtistById(int id) async {
    try {
      var client = TwoSidesHttp();
      var uri = Uri.parse('${httpsHead}${baseUrl}/artist');

      Map<String, String>? headersJson = {'id': id.toString()};

      var response = client.get(uri, headers: headersJson);

      return await client.handleResponse<Artist>(
          response, (json) => Artist.fromJson(json));
    } catch (e) {
      log("Error API: " + e.toString());
      rethrow;
    }
  }

  @override
  Future<Auth> createArtist(String name, String style) async {
    try {
      var client = TwoSidesHttp();
      var uri = Uri.parse('${httpsHead}${baseUrl}/artist');

      Map<String, String>? headersJson = {'name': name, 'style': style};

      log(name);

      var response = client.post(uri, headers: headersJson);

      return await client.handleResponse<Auth>(
          response, (json) => Auth.fromJson(json));
    } catch (e) {
      log("Error API: " + e.toString());
      rethrow;
    }
  }
//
  //@override
  //Future<void> deleteArtist(int id) async {
  //  final response =
  //      await http.delete(Uri.parse('$baseUrl/artists/$id'));
//
  //  if (response.statusCode != 204) {
  //    throw Exception('Failed to delete artist');
  //  }
  //}

  @override
  Future<List<Asset>> getAllAssetsOfArtist(int artistId) async {
    try {
      var client = TwoSidesHttp();

      var uri = Uri.parse('${httpsHead}${baseUrl}/entity/assets');

      Map<String, String>? headersJson = {
        'entityType': "artist",
        'entityId': artistId.toString()
      };

      var response = client.get(uri, headers: headersJson);

      return await client.handleListResponse<Asset>(
          response, (json) => Asset.fromJson(json));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Link>> getAllLinksOfArtist(int artistId) async {
    try {
      var client = TwoSidesHttp();

      var uri = Uri.parse('${httpsHead}${baseUrl}/entity/links');

      Map<String, String>? headersJson = {
        'entityType': "artist",
        'entityId': artistId.toString()
      };

      var response = client.get(uri, headers: headersJson);

      return await client.handleListResponse<Link>(
          response, (json) => Link.fromJson(json));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Auth> updateArtist(Artist artist) async {
    try {
      var client = TwoSidesHttp();

      var uri = Uri.parse('${httpsHead}${baseUrl}/artist');

      var response = client.put(uri,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "id": artist.id,
            "name": artist.name,
            "location": artist.location ?? "",
            "style": artist.style ?? "",
            "description": artist.description ?? ""
          }));

      return await client.handleResponse<Auth>(
          response, (json) => Auth.fromJson(json));
    } catch (e) {
      rethrow;
    }
  }
}
