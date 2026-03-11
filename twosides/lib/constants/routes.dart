import 'package:url_launcher/url_launcher.dart';

final String httpsHead = "https://";

class RoutingPageNames {
  static const String booking = "/booking";
  static const String about = "/about";
  static const String prod = "/prod";
  static const String admin = "/adm";
  static const String adminConnect = "/admin";
  static const String adminInterface = "/admin/interface";
  static const String artist = "/artist";
}

Future<void> goToUrl(Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
