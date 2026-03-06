import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twosides/twosides_provider.dart';
import 'package:twosides/models/auth.dart';
import 'package:twosides/http/repositories/admin_repository.dart';

final adminConnectPageViewModelProvider =
    StateNotifierProvider.autoDispose<AdminConnectPageViewModel, AdminConnectPageViewState>(
        (ref) {
  return AdminConnectPageViewModel(ref.watch(adminRepositoryProvider));
});

class AdminConnectPageViewModel extends StateNotifier<AdminConnectPageViewState> {
  final AdminRepository _adminRepository;

  AdminConnectPageViewModel(this._adminRepository)
      : super(AdminConnectPageViewState(const AsyncData(null)));

  Future<void> login(String email, String password) async {
    state = AdminConnectPageViewState(const AsyncLoading());
    try {
      Auth admin = await _adminRepository.login(email, password);
      state = AdminConnectPageViewState(AsyncData(admin));
    } catch (e, s) {
      state = AdminConnectPageViewState(AsyncError(e, s));
    }
  }
}

class AdminConnectPageViewState {
  final AsyncValue<Auth?> admin;
  AdminConnectPageViewState(this.admin);
}
