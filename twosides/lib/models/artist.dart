import 'package:twosides/models/asset.dart';
import 'package:twosides/models/link.dart';
import 'dart:developer';

class Artist {
  final int id;
  final String name;
  String? location;
  String? style;
  String? description;
  String? label;
  final List<Asset>? assets;
  final List<Link>? links;

  set assets(List<Asset>? newAssets) {
    if (newAssets == null) {
      throw ArgumentError('nawAssets cannot be empty');
    }
    assets = newAssets;
  }

  set links(List<Link>? newLinks) {
    if (newLinks == null) {
      throw ArgumentError('nawLinkss cannot be empty');
    }
    links = newLinks;
  }

  Artist({
    required this.id,
    required this.name,
    this.location,
    this.style,
    this.description,
    this.label,
    this.assets,
    this.links,
  });

  factory Artist.fromJson(dynamic json) {
    log(json.toString());
    return Artist(
      id: json['id']!,
      name: json['name']! as String,
      location: json['location'] == null ? "" : json['location'] as String,
      style: json['style'] == null ? "" : json['style'] as String,
      description:
          json['description'] == null ? "" : json['description'] as String,
      label: json['label'] == null ? "" : json['label'] as String,
    );
  }

  Artist copyWith({
    List<Asset>? assets,
    List<Link>? links,
  }) {
    return Artist(
      id: id,
      name: name,
      style: style,
      location: location,
      description: description,
      label: label,
      assets: assets ?? this.assets,
      links: links ?? this.links,
    );
  }
}
