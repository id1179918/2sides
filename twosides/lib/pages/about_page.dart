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
        //Container(
        //  width: MediaQuery.of(context).size.width,
        //  height: MediaQuery.of(context).size.height * 0.8,
        //  child:
        //    bookingPageViewState.artists.when(
        //      data: (_) {
        //        List<Widget> artistGallery = [];
        //        for (int i = 0; i < bookingPageViewState.artists.value!.length; i++) {
        //          artistGallery.add(ArtistTile(artist: bookingPageViewState.artists.value![i]));
        //        }
        //        return GridView.count(
        //          primary: false,
        //          crossAxisCount: 4,
        //          children: artistGallery,
        //        );
        //      },
        //      error: (error, stacktrace) {
        //        return Column(
        //          children: [
        //            Text(error.toString()),
        //            Text(stacktrace.toString())
        //          ]
        //        );
        //      },
        //      loading: () => Container(
        //        width: MediaQuery.of(context).size.width,
        //        height: MediaQuery.of(context).size.height,
        //        color: Colors.black.withOpacity(0.6),
        //        child: Center(
        //          child: CircularProgressIndicator(
        //            color: TwoSidesColors.primaryColor,
        //          ),
        //        ),
        //      ),
        //    ),
        //),
        PageFooter(),
      ]),
    );
  }
}
