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
  int? position;
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
    this.position,
    this.assets,
    this.links,
  });

  factory Artist.fromJson(dynamic json) {
    return Artist(
      id: json['id']!,
      name: json['name']! as String,
      location: json['location'] == null ? "" : json['location'] as String,
      style: json['style'] == null ? "" : json['style'] as String,
      description:
          json['description'] == null ? "" : json['description'] as String,
      label: json['label'] == null ? "" : json['label'] as String,
      position: json['pos'] == null ? null : json['pos'] as int,
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
      position: position,
      assets: assets ?? this.assets,
      links: links ?? this.links,
    );
  }
}

List<Artist> sortByPosition(List<Artist> artists) {
  artists.sort((a, b) {
    // both null — keep original order
    if (a.position == null && b.position == null) return 0;
    // a is null — push a after b
    if (a.position == null) return 1;
    // b is null — push b after a
    if (b.position == null) return -1;
    // both have position — sort ascending (0 first)
    return a.position!.compareTo(b.position!);
  });
  return artists;
}
