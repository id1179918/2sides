import 'package:twosides/models/link.dart';
import 'dart:developer';

class EntityLink {
  EntityLink({
    required this.type,
    this.links,
  });

  factory EntityLink.fromJson(Map<String, Object?> json) {
    return EntityLink(
      type: json['type']! as String,
      links: json['links'] == null ? <Link>[] : (json['links'] as List)
        .map((x) => Link.fromJson(x as Map<String, dynamic>))
        .toList(),
    );
  }

  final String type;
  final List<Link>? links;
}