import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:twosides/constants/colors.dart';
import 'package:twosides/constants/routes.dart';
import 'package:twosides/gen/assets.gen.dart';
import 'package:twosides/pages/booking_page.dart';
import 'package:twosides/pages/about_page.dart';
import 'package:twosides/pages/error_page.dart';
import 'package:twosides/pages/protected_page.dart';
import 'package:twosides/pages/admin_connect_page.dart';
import 'package:twosides/pages/admin_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:twosides/pages/artist_page.dart';
import 'package:twosides/widgets/page_headers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        RoutingPageNames.booking: (context) => BookingPage(),
        RoutingPageNames.about: (context) => AboutPage(),
        RoutingPageNames.adminConnect: (context) => AdminConnectPage(),
        RoutingPageNames.adminInterface: (context) => ProtectedPage(child: AdminInterfacePage()),
      },
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name!);

        if (uri.pathSegments.length == 2 &&
            uri.pathSegments.first == 'artist') {
          final artistId = int.tryParse(uri.pathSegments[1]);

          if (artistId == null) {
            return errorRoute();
          }

          return MaterialPageRoute(
            builder: (_) => ArtistPage(artistId: artistId),
            settings: settings,
          );
        }

        return errorRoute();
      },
      title: '2Sides',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Acceuil(),
    );
  }
}

class ButtonAcceuil extends StatefulWidget {
  const ButtonAcceuil(
      {super.key, required this.buttonText, required this.route});

  final String buttonText;
  final String route;

  @override
  State<ButtonAcceuil> createState() => _ButtonAcceuilState();
}

class _ButtonAcceuilState extends State<ButtonAcceuil> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, widget.route);
        },
        child: AbsorbPointer(
          child: Container(
            height: 80,
            width: MediaQuery.of(context).size.width * 0.2,
            decoration: BoxDecoration(
              color: TwoSidesColors.backgroundColor,
              border: Border.all(
                width: 2,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                widget.buttonText,
                style: const TextStyle(
                    color: TwoSidesColors.textColor,
                    fontFamily: 'Prophet',
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Acceuil extends StatefulWidget {
  const Acceuil({super.key});
  @override
  State<Acceuil> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Acceuil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: AlignmentGeometry.topCenter,
        children: [
          Image(
            image: Assets.images.subside2025Ldscarla0745.provider(),
            fit: BoxFit.fitWidth,
          ),
          Image.asset(
            scale: 3,
            Assets.images.twosidesgif2.path,
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: HomePageHeader(),
          ),
          //    const Row(
          //    mainAxisAlignment: MainAxisAlignment.center,
          //    children: [
          //      ButtonAcceuil(
          //        buttonText: "Booking",
          //        route: RoutingPageNames.booking,
          //      ),
          //      ButtonAcceuil(
          //        buttonText: "Prod Event",
          //        route: RoutingPageNames.booking,
          //      ),
          //      ButtonAcceuil(
          //        buttonText: "Admin",
          //        route: RoutingPageNames.booking,
          //      ),
          //      ButtonAcceuil(
          //        buttonText: "About",
          //        route: RoutingPageNames.about,
          //      )
          //    ],
          //  ),
          //),
          //Image(
          //  width: 100,
          //  height: 100,
          //  image: Assets.images.lOGO2sidesEnvent.provider(),
          //  alignment: Alignment.center,
          //),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
