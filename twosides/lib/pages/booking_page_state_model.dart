import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twosides/models/artist.dart';
import 'package:twosides/http/repositories/artist_repository.dart';
import 'package:twosides/twosides_provider.dart';
import 'package:twosides/models/entity_asset.dart';
import 'dart:developer';

final bookingPageViewModelProvider = StateNotifierProvider.autoDispose<BookingPageViewModel, BookingPageViewState>(
  (ref) {
    return BookingPageViewModel(ref.watch(artistRepositoryProvider));
  }
);

class BookingPageViewModel extends StateNotifier<BookingPageViewState> {
  final ArtistRepository _artistRepository;
  BookingPageViewModel(this._artistRepository): super(BookingPageViewState(const AsyncLoading())) {
    loadAllArtists();
  }

  //Future<void> loadAllArtists() async {
  //  state = BookingPageViewState(const AsyncLoading());
  //  try {
  //    List<Artist> artists = await _artistRepository.getAllArtists();
  //    state = BookingPageViewState(AsyncData(artists));
  //    await loadAllArtistsAssets();
  //  } catch (e, s) {
  //    state = BookingPageViewState(AsyncError(e, s));
  //  }
  //}

  Future<void> loadAllArtists() async {
    state = BookingPageViewState(const AsyncLoading());
    try {
      List<Artist> artists = await _artistRepository.getAllArtists();
      List<Artist> artistsWithAssets = await loadAllArtistsAssets(artists);
      state = BookingPageViewState(AsyncData(artistsWithAssets));
    } catch (e, s) {
      state = BookingPageViewState(AsyncError(e, s));
    }
  }

  Future<List<Artist>> loadAllArtistsAssets(List<Artist> artists) async {
    if (artists == null) {
      throw FormatException('Failed to load artists');
    };

    final oldArtists = artists;

    try {
      final List<Artist> updatedArtists = [];

      for (final artist in oldArtists) {
        final assets =
            await _artistRepository.getAllAssetsOfArtist(artist.id);

        updatedArtists.add(
          artist.copyWith(assets: assets),
        );
      }
      return (updatedArtists);
    } catch (e, s) {
      rethrow;
    }
  }

  //Future<void> loadAllArtistsAssets() async {
  //  final currentArtistsAsync = state.artists;
//
  //  if (!currentArtistsAsync.hasValue) {
  //    throw FormatException('Failed to load artists');
  //  };
//
  //  final oldArtists = currentArtistsAsync.value!;
//
  //  try {
  //    final List<Artist> updatedArtists = [];
//
  //    for (final artist in oldArtists) {
  //      final assets =
  //          await _artistRepository.getAllAssetsOfArtist(artist.id);
//
  //      updatedArtists.add(
  //        artist.copyWith(assets: assets),
  //      );
  //    }
  //    state = BookingPageViewState(
  //      AsyncData(updatedArtists),
  //    );
  //  } catch (e, s) {
  //    state = BookingPageViewState(
  //      AsyncError(e, s),
  //    );
  //  }
  //}
}

class BookingPageViewState {
  final AsyncValue<List<Artist>?> artists;
  BookingPageViewState(this.artists);
}