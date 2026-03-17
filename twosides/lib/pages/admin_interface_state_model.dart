import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twosides/twosides_provider.dart';
import 'package:twosides/models/auth.dart';
import 'package:twosides/models/artist.dart';
import 'package:twosides/models/entity_asset.dart';
import 'package:twosides/http/repositories/admin_repository.dart';
import 'package:twosides/http/repositories/artist_repository.dart';
import 'package:twosides/http/repositories/asset_repository.dart';
import 'package:twosides/http/repositories/link_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:twosides/models/asset.dart';
import 'package:cross_file/cross_file.dart';
import 'dart:developer';

final adminInterfaceViewModelProvider = StateNotifierProvider.autoDispose<
    AdminInterfaceViewModel, AdminInterfaceViewState>((ref) {
  return AdminInterfaceViewModel(
      ref.watch(adminRepositoryProvider),
      ref.watch(artistRepositoryProvider),
      ref.watch(assetRepositoryProvider),
      ref.watch(linkRepositoryProvider));
});

enum AdminInterfacePageTypes { artist, event, about }

class AdminInterfaceViewModel extends StateNotifier<AdminInterfaceViewState> {
  final AdminRepository _adminRepository;
  final ArtistRepository _artistRepository;
  final AssetRepository _assetRepository;
  final LinkRepository _linkRepository;

  AdminInterfaceViewModel(this._adminRepository, this._artistRepository,
      this._assetRepository, this._linkRepository)
      : super(AdminInterfaceViewState(
            const AsyncData(AdminInterfacePageTypes.artist),
            AsyncData(null),
            AsyncData(null))) {
    loadAllArtists();
  }

  void changeInterfacePage(AdminInterfacePageTypes newPageType) {
    state = AdminInterfaceViewState(
      AsyncData(newPageType),
      state.artists,
      state.admin,
    );
  }

  Future<void> loadAllArtists() async {
    state = AdminInterfaceViewState(
        state.pageType, const AsyncLoading(), state.admin);
    try {
      List<Artist> artists = await _artistRepository.getAllArtists();
      List<Artist> artistsWithAssets = await loadAllArtistsAssets(artists);
      List<Artist> artistsWithLinks =
          await loadAllArtistLinks(artistsWithAssets);
      state = AdminInterfaceViewState(
          state.pageType, AsyncData(artistsWithLinks), state.admin);
    } catch (e, s) {
      state = AdminInterfaceViewState(
          state.pageType, AsyncError(e, s), state.admin);
    }
  }

  Future<List<Artist>> loadAllArtistsAssets(List<Artist> artists) async {
    if (artists == null) {
      throw FormatException('Failed to load artists');
    }
    ;

    final oldArtists = artists;

    try {
      final List<Artist> updatedArtists = [];

      for (final artist in oldArtists) {
        final assets = await _artistRepository.getAllAssetsOfArtist(artist.id);

        updatedArtists.add(
          artist.copyWith(assets: assets),
        );
      }
      return (updatedArtists);
    } catch (e, s) {
      rethrow;
    }
  }

  Future<List<Artist>> loadAllArtistLinks(List<Artist> artists) async {
    if (artists == null) {
      throw FormatException('Failed to load artist');
    }
    ;

    final oldArtists = artists;

    try {
      final List<Artist> updatedArtists = [];

      for (final artist in oldArtists) {
        final links = await _artistRepository.getAllLinksOfArtist(artist.id);

        updatedArtists.add(
          artist.copyWith(links: links),
        );
      }
      return (updatedArtists);
    } catch (e, s) {
      rethrow;
    }
  }

  Future<void> logout() async {
    state = AdminInterfaceViewState(
        state.pageType, state.artists, const AsyncLoading());
    try {
      await _adminRepository.logout();
      Auth adminLogout = Auth(status: "logout");
      state = AdminInterfaceViewState(
          state.pageType, state.artists, AsyncData(adminLogout));
    } catch (e, s) {
      state = AdminInterfaceViewState(
          state.pageType, state.artists, AsyncError(e, s));
    }
  }

  Future<void> updateArtist(Artist artist) async {
    state = AdminInterfaceViewState(
        state.pageType, state.artists, const AsyncLoading());
    try {
      Auth admin = await _artistRepository.updateArtist(artist);
      state = AdminInterfaceViewState(
          state.pageType, state.artists, AsyncData(admin));
    } catch (e, s) {
      state = AdminInterfaceViewState(
          state.pageType, state.artists, AsyncError(e, s));
    }
  }

  Future<void> createArtist(String name, String style) async {
    state = AdminInterfaceViewState(
        state.pageType, state.artists, const AsyncLoading());
    try {
      Auth newArtist = await _artistRepository.createArtist(name, style);
      state = AdminInterfaceViewState(
          state.pageType, state.artists, AsyncData(newArtist));
    } catch (e, s) {
      state = AdminInterfaceViewState(
          state.pageType, state.artists, AsyncError(e, s));
    }
  }

  Future<void> deleteArtist(int id) async {
    state = AdminInterfaceViewState(
        state.pageType, state.artists, const AsyncLoading());
    try {
      Auth admin = await _artistRepository.deleteArtist(id);
      state = AdminInterfaceViewState(
          state.pageType, state.artists, AsyncData(admin));
    } catch (e, s) {
      state = AdminInterfaceViewState(
          state.pageType, state.artists, AsyncError(e, s));
    }
  }

  Future<void> uploadAssetArtist(int artistId, XFile asset, String role) async {
    state = AdminInterfaceViewState(
        state.pageType, state.artists, const AsyncLoading());
    try {
      int assetId = await _assetRepository.uploadAsset(asset);
      Auth admin =
          await _assetRepository.assignAssetArtist(assetId, artistId, role);
      //Auth admin = await _assetRepository.upsertAssetArtist(artistId, role);
      state = AdminInterfaceViewState(
          state.pageType, state.artists, AsyncData(admin));
    } catch (e, s) {
      state = AdminInterfaceViewState(
          state.pageType, state.artists, AsyncError(e, s));
    }
  }

  Future<void> deleteAsset(int assetId) async {
    state = AdminInterfaceViewState(
        state.pageType, state.artists, const AsyncLoading());
    try {
      Auth admin = await _assetRepository.deleteAsset(assetId);
      state = AdminInterfaceViewState(
          state.pageType, state.artists, AsyncData(admin));
    } catch (e, s) {
      state = AdminInterfaceViewState(
          state.pageType, state.artists, AsyncError(e, s));
    }
  }

  Future<void> upsertLinkArtist(String linkType, String url, String label,
      String entityType, String entityId) async {
    state = AdminInterfaceViewState(
        state.pageType, state.artists, const AsyncLoading());
    try {
      Auth admin = await _linkRepository.upsertLinkEntity(
          linkType, url, label, entityType, entityId);
      state = AdminInterfaceViewState(
          state.pageType, state.artists, AsyncData(admin));
    } catch (e, s) {
      state = AdminInterfaceViewState(
          state.pageType, state.artists, AsyncError(e, s));
    }
  }

  Future<void> deleteLink(int linkId) async {
    state = AdminInterfaceViewState(
        state.pageType, state.artists, const AsyncLoading());
    try {
      Auth admin = await _linkRepository.deleteLink(linkId);
      state = AdminInterfaceViewState(
          state.pageType, state.artists, AsyncData(admin));
    } catch (e, s) {
      state = AdminInterfaceViewState(
          state.pageType, state.artists, AsyncError(e, s));
    }
  }
}

class AdminInterfaceViewState {
  final AsyncValue<AdminInterfacePageTypes> pageType;
  final AsyncValue<List<Artist>?> artists;
  final AsyncValue<Auth?> admin;
  AdminInterfaceViewState(this.pageType, this.artists, this.admin);
}
