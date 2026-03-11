import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants/env.dart';

final String imageUrl = Env.imageUrl;

Future<Uint8List> fetchAssetBytes(int assetId) async {
  final uri = Uri.parse('$imageUrl/asset/$assetId');

  final response = await http.get(
    uri,
    headers: {
      'Accept': 'image/*',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to load image');
  }

  return response.bodyBytes;
}

class AssetImageCache {
  static final Map<int, Uint8List> _cache = {};

  static Uint8List? get(int assetId) => _cache[assetId];

  static void put(int assetId, Uint8List bytes) {
    _cache[assetId] = bytes;
  }

  static bool contains(int assetId) => _cache.containsKey(assetId);
}
