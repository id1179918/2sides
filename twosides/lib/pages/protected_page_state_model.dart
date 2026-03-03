import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twosides/twosides_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:twosides/models/auth.dart';
import 'package:twosides/http/repositories/admin_repository.dart';

final protectedPageViewModelProvider =
    StateNotifierProvider.autoDispose<ProtectedPageViewModel, ProtectedPageViewState>(
        (ref) {
  return ProtectedPageViewModel(ref.watch(adminRepositoryProvider));
});

class ProtectedPageViewModel extends StateNotifier<ProtectedPageViewState> {
  final AdminRepository _adminRepository;

  ProtectedPageViewModel(this._adminRepository)
      : super(ProtectedPageViewState(const AsyncData(null))) {
        checkAdmin();
      }

  Future<void> checkAdmin() async {
    state = ProtectedPageViewState(const AsyncLoading());
    try {
      Auth admin = await _adminRepository.adminCheck();
      log("admin: " + admin.toString());
      state = ProtectedPageViewState(AsyncData(admin));
    } catch (e, s) {
      state = ProtectedPageViewState(AsyncError(e, s));
    }
  }
}

class ProtectedPageViewState {
  final AsyncValue<Auth?> admin;
  ProtectedPageViewState(this.admin);
}
