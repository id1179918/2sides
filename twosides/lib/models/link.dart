import 'dart:developer';

enum LinkType {
  website,
  merch,
  instagram,
  facebook,
  youtube,
  soundcloud,
  bandcamp,
  mixcloud,
  ticketing,
  ra,
  live,
  release,
}

LinkType stringToLinkType(String linkType) {
  LinkType lt = LinkType.website;
  switch (linkType) {
    case "website":
      lt = LinkType.website;
      break;
    case "merch":
      lt = LinkType.merch;
      break;
    case "instagram":
      lt = LinkType.instagram;
      break;
    case "facebook":
      lt = LinkType.facebook;
      break;
    case "youtube":
      lt = LinkType.youtube;
      break;
    case "soundcloud":
      lt = LinkType.soundcloud;
      break;
    case "bandcamp":
      lt = LinkType.bandcamp;
      break;
    case "mixcloud":
      lt = LinkType.mixcloud;
      break;
    case "ticketing":
      lt = LinkType.ticketing;
      break;
    case "ra":
      lt = LinkType.ra;
      break;
    case "live":
      lt = LinkType.live;
      break;
    case "release":
      lt = LinkType.release;
      break;
    default:
      lt = LinkType.website;
      break;
  }
  return lt;
}

class Link {
  Link({
    required this.id,
    required this.type,
    required this.url,
    required this.label,
  });

  factory Link.fromJson(Map<String, Object?> json) {
    return Link(
      id: json['id']! as int,
      type: stringToLinkType(json['type']! as String),
      url: json['url']! as String,
      label: json['label']! as String,
    );
  }

  final int id;
  final LinkType type;
  final String url;
  final String label;
}