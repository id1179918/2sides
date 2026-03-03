import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twosides/models/artist.dart';
import 'package:twosides/models/asset.dart';
import 'package:twosides/twosides_provider.dart';
import 'package:twosides/pages/protected_page_state_model.dart';
import 'package:twosides/pages/artist_page.dart';
import 'package:twosides/pages/admin_connect_page.dart';
import 'package:twosides/constants/colors.dart';
import 'package:twosides/gen/assets.gen.dart';
import 'package:twosides/widgets/page_headers.dart';
import 'package:twosides/widgets/page_footer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:twosides/constants/routes.dart';
import 'package:twosides/asset_image_cache.dart';

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
            Navigator.pushReplacementNamed(context, '${RoutingPageNames.adminConnect}');
          });
          return const SizedBox.shrink();
        }
        log("works");
        return child;
      },
    );
  }
}
