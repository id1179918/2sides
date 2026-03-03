import 'package:twosides/models/artist.dart';
import 'package:twosides/models/auth.dart';
import 'package:twosides/models/link.dart';
import 'dart:io';


abstract class LinkRepository {
  Future<Auth> upsertLinkEntity(String linkType, String url, String label, String entityType, String entityId);
  Future<Auth> deleteLink(int linkId);
}