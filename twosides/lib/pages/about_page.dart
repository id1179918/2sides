import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twosides/models/artist.dart';
import 'package:twosides/twosides_provider.dart';
import 'package:twosides/pages/booking_page_state_model.dart';
import 'package:twosides/constants/colors.dart';
import 'package:twosides/gen/assets.gen.dart';
import 'package:twosides/widgets/page_headers.dart';
import 'package:twosides/widgets/page_footer.dart';

class AboutPage extends ConsumerWidget {
  AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(children: [
        AboutPageHeader(),
        Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.58,
            child: Row(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Image.asset(
                  scale: 5,
                  Assets.images.lOGO2sidesEnvent.path,
                ),
              ),
            ]),
          ),
        ]),
        PageFooter(),
      ]),
    );
  }
}
