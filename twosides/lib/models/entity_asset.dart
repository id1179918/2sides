import 'package:twosides/models/asset.dart';

class EntityAsset {
  EntityAsset({
    required this.role,
    this.assets,
  });

  factory EntityAsset.fromJson(Map<String, Object?> json) {
    return EntityAsset(
      role: json['role']! as String,
      assets: json['assets'] == null ? <Asset>[] : (json['assets'] as List)
        .map((x) => Asset.fromJson(x as Map<String, dynamic>))
        .toList(),
    );
  }

  final String role;
  final List<Asset>? assets;
}