import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twosides/models/artist.dart';
import 'package:twosides/twosides_provider.dart';
import 'package:twosides/pages/booking_page_state_model.dart';
import 'package:twosides/constants/colors.dart';
import 'package:twosides/gen/assets.gen.dart';
import 'package:twosides/widgets/page_headers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:twosides/widgets/page_footer.dart';

class AdminOrgPage extends ConsumerWidget {
  const AdminOrgPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(children: [
        const AdminOrgPageHeader(),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.58,
            child: Column(
              children: [
                Image.asset(
                  scale: 5,
                  Assets.images.lOGO2sidesEnvent.path,
                ),
                const Text(
                  "Désolé, cette page n'est pas encore disponible...",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Boldonse',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    //height: 0.9,
                  ),
                ),
              ],
            )),
        const PageFooter(),
      ]),
    );
  }
}
