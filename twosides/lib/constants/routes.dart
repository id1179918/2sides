import 'package:url_launcher/url_launcher.dart';

class RoutingPageNames {
  static const String booking = "/booking";
  static const String about = "/about";
  static const String adminConnect = "/admin";
  static const String adminInterface = "/admin/interface";
  static const String artist = "/artist";
}

Future<void> goToUrl(Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}