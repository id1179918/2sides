import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twosides/models/artist.dart';
import 'package:twosides/http/repositories/artist_repository.dart';
import 'package:twosides/twosides_provider.dart';
import 'package:twosides/models/entity_asset.dart';
import 'dart:developer';

final artistPageViewModelProvider = StateNotifierProvider.autoDispose.family<ArtistPageViewModel, ArtistPageViewState, int>(
  (ref, artistId) {
    return ArtistPageViewModel(ref.watch(artistRepositoryProvider), artistId);
  }
);

class ArtistPageViewModel extends StateNotifier<ArtistPageViewState> {
  final ArtistRepository _artistRepository;
  final int artistId;
  ArtistPageViewModel(this._artistRepository, this.artistId): super(ArtistPageViewState(const AsyncData(null), const AsyncData(null))) {
    loadArtist(artistId);
    loadAllArtists();
  }

  Future<void> loadArtist(int artistId) async {
    state = ArtistPageViewState(const AsyncLoading(), state.artists);
    try {
      Artist artist = await _artistRepository.getArtistById(artistId);
      Artist artistWithAssets = await loadArtistAssets(artist);
      Artist artistWithLinks = await loadArtistLinks(artistWithAssets);
      state = ArtistPageViewState(AsyncData(artistWithLinks), state.artists);
    } catch (e, s) {
      state = ArtistPageViewState(AsyncError(e, s), state.artists);
    }
  }

  Future<Artist> loadArtistAssets(Artist artist) async {
    if (artist == null) {
      throw FormatException('Failed to load artist');
    };

    try {
      final Artist updatedArtist;

      final assets = await _artistRepository.getAllAssetsOfArtist(artist.id);

      updatedArtist = artist.copyWith(assets: assets);

      return (updatedArtist);
    } catch (e, s) {
      rethrow;
    }
  }

  Future<Artist> loadArtistLinks(Artist artist) async {
    if (artist == null) {
      throw FormatException('Failed to load artist');
    };

    try {
      final Artist updatedArtist;

      final links = await _artistRepository.getAllLinksOfArtist(artist.id);

      updatedArtist = artist.copyWith(links: links);

      return (updatedArtist);
    } catch (e, s) {
      rethrow;
    }
  }

  Future<void> loadAllArtists() async {
    state = ArtistPageViewState(state.artist, const AsyncLoading());
    try {
      List<Artist> artists = await _artistRepository.getAllArtists();
      state = ArtistPageViewState(state.artist, AsyncData(artists));
    } catch (e, s) {
      state = ArtistPageViewState(state.artist, AsyncError(e, s));
    }
  }
}

class ArtistPageViewState {
  final AsyncValue<Artist?> artist;
  final AsyncValue<List<Artist>?> artists;
  ArtistPageViewState(this.artist, this.artists);
}