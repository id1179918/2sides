import 'dart:developer';

enum AssetRole { primary, secondary, background, gallery, banner, presskit }

AssetRole stringToAssetRole(String role) {
  AssetRole r = AssetRole.gallery;
  switch (role) {
    case "primary":
      r = AssetRole.primary;
      break;
    case "secondary":
      r = AssetRole.secondary;
      break;
    case "background":
      r = AssetRole.background;
      break;
    case "gallery":
      r = AssetRole.gallery;
      break;
    case "banner":
      r = AssetRole.banner;
      break;
    case "presskit":
      r = AssetRole.presskit;
      break;
  }
  return r;
}

String assetRoleToString(AssetRole role) {
  String s = "gallery";
  switch (role) {
    case AssetRole.primary:
      s = "primary";
      break;
    case AssetRole.secondary:
      s = "secondary";
      break;
    case AssetRole.background:
      s = "background";
      break;
    case AssetRole.gallery:
      s = "gallery";
      break;
    case AssetRole.banner:
      s = "banner";
      break;
    case AssetRole.presskit:
      s = "presskit";
      break;
  }
  return s;
}

class Asset {
  Asset({
    required this.role,
    required this.id,
    required this.originalName,
    required this.storageKey,
    required this.mimeType,
    required this.sizeBytes,
    this.checkSum,
    this.fileExtension,
    required this.createdAt,
  });

  factory Asset.fromJson(Map<String, Object?> json) {
    return Asset(
      role: stringToAssetRole(json['role']! as String),
      id: json['id']! as int,
      originalName: json['original_name']! as String,
      storageKey: json['storage_key']! as String,
      mimeType: json['mime_type']! as String,
      sizeBytes: int.parse(json['size_bytes']! as String),
      checkSum: json['check_sum'] == null ? "" : json['check_sum'] as String,
      fileExtension: json['file_extension'] == null
          ? ""
          : json['file_extension'] as String,
      createdAt: DateTime.parse(json['created_at']! as String),
    );
  }

  final AssetRole role;
  final int id;
  final String originalName;
  final String storageKey;
  final String mimeType;
  final int sizeBytes;
  final String? checkSum;
  final String? fileExtension;
  final DateTime createdAt;
}
