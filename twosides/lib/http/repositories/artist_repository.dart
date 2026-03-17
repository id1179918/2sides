import 'package:twosides/models/artist.dart';
import 'package:twosides/models/auth.dart';
import 'package:twosides/models/asset.dart';
import 'package:twosides/models/link.dart';

abstract class ArtistRepository {
  Future<Artist> getArtistByName(String name);
  Future<List<Artist>> getAllArtists();
  Future<Artist> getArtistById(int id);
  Future<Auth> createArtist(String name, String style);
  Future<Auth> deleteArtist(int id);
  Future<List<Asset>> getAllAssetsOfArtist(int artistId);
  Future<List<Link>> getAllLinksOfArtist(int artistId);
  Future<Auth> updateArtist(Artist artist);
}
