import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twosides/pages/protected_page_state_model.dart';
import 'package:twosides/pages/admin_connect_page.dart';
import 'package:twosides/constants/routes.dart';

class ProtectedPage extends ConsumerWidget {
  final Widget child;

  const ProtectedPage({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final protectedPageViewState = ref.watch(protectedPageViewModelProvider);
    //ref.read(protectedPageViewModelProvider.notifier).checkAdmin();

    return protectedPageViewState.admin.when(
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => AdminConnectPage(),
      data: (_) {
        log("protected page data field");
        if (protectedPageViewState.admin.value == null) {
          log(protectedPageViewState.admin.value.toString());
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
                context, '${RoutingPageNames.adminConnect}');
          });
          return const SizedBox.shrink();
        }
        log("works");
        return child;
      },
    );
  }
}
