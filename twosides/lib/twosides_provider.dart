import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twosides/constants/env.dart';
import 'package:twosides/http/repositories/artist_repository.dart';
import 'package:twosides/http/repositories/artist_repository_impl.dart';
import 'package:twosides/http/repositories/admin_repository.dart';
import 'package:twosides/http/repositories/admin_repository_impl.dart';
import 'package:twosides/http/repositories/asset_repository.dart';
import 'package:twosides/http/repositories/asset_repository_impl.dart';
import 'package:twosides/http/repositories/link_repository.dart';
import 'package:twosides/http/repositories/link_repository_impl.dart';
import 'package:twosides/http/two_sides_http.dart';
import 'package:http/http.dart' as http;
import 'package:http/browser_client.dart';

final artistRepositoryProvider = Provider<ArtistRepository>((ref) {
  return ArtistRepositoryImpl();
});

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepositoryImpl();
});

final assetRepositoryProvider = Provider<AssetRepository>((ref) {
  return AssetRepositoryImpl();
});

final linkRepositoryProvider = Provider<LinkRepository>((ref) {
  return LinkRepositoryImpl();
});

final authProvider = FutureProvider<bool>((ref) async {
  var client = TwoSidesHttp();
  final String baseUrl = Env.baseUrl;
  var uri = Uri.https(baseUrl, '/admin/me', null);
  log(uri.toString());
  final response = await client.get(uri);
  log(response.statusCode.toString());

  return response.statusCode == 200;
});
