import 'dart:html' as html;

void downloadFile(int asset_id, String artist_name) {
  final anchor =
      html.AnchorElement(href: "https://2sides-agency.fr/api/asset/${asset_id}")
        ..setAttribute('download', "presskit-${artist_name}.pdf")
        ..click();
}
