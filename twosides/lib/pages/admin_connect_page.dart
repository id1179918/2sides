import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twosides/models/artist.dart';
import 'package:twosides/twosides_provider.dart';
import 'package:twosides/pages/admin_connect_page_state_model.dart';
import 'package:twosides/constants/colors.dart';
import 'package:twosides/constants/routes.dart';
import 'package:twosides/gen/assets.gen.dart';
import 'package:twosides/widgets/page_headers.dart';

class AdminConnectPage extends ConsumerWidget {
  AdminConnectPage({super.key});

  final TextEditingController _emailController =
      TextEditingController(text: "Email");
  final TextEditingController _passwordController =
      TextEditingController(text: "Mot de passe");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminConnectPageViewState =
        ref.watch(adminConnectPageViewModelProvider);

    ref.listen<AdminConnectPageViewState>(
      adminConnectPageViewModelProvider,
      (_, currentState) {
        currentState.admin.whenOrNull(
          skipError: true,
          data: (admin) {
            if (admin != null && admin.status == "success") {
              log(admin.status);
              Navigator.pushNamed(
                  context, '${RoutingPageNames.adminInterface}');
            }
          },
          error: (error, _) {
            log(error.toString());
          },
        );
      },
    );

    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                0, 0, 0, MediaQuery.of(context).size.height * 0.1),
            child: Image.asset(
              scale: 3,
              Assets.images.lOGO2sidesEnvent.path,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.17,
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.17,
              child: TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                obscureText: true,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: adminConnectPageViewState.admin is AsyncLoading
                ? null
                : () async {
                    ref
                        .read(adminConnectPageViewModelProvider.notifier)
                        .login(_emailController.text, _passwordController.text);
                  },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                backgroundColor: TwoSidesColors.primaryColor,
                minimumSize: const Size(10, 60)),
            child: Text(
              "Se connecter",
              style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'signika',
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ]),
      ),
    );
  }
}
