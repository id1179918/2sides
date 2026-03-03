import 'package:twosides/models/artist.dart';
import 'package:twosides/models/auth.dart';
import 'package:twosides/models/asset.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:cross_file/cross_file.dart';


abstract class AssetRepository {
  Future<int> uploadAsset(XFile file);
  Future<Auth> assignAssetArtist(int assetId, int artistId, String role);
  //Future<Auth> assignAssetEvent(int assetId, int eventId, String role);
  Future<Auth> upsertAssetArtist(int artistId, String role);
  Future<Auth> deleteAsset(int assetId);
}