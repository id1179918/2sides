// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/LOGO_2SIDES.png
  AssetGenImage get logo2sides =>
      const AssetGenImage('assets/images/LOGO_2SIDES.png');

  /// File path: assets/images/LOGO_2sides_envent.png
  AssetGenImage get lOGO2sidesEnvent =>
      const AssetGenImage('assets/images/LOGO_2sides_envent.png');

  /// File path: assets/images/LOGO_nb.png
  AssetGenImage get lOGONb => const AssetGenImage('assets/images/LOGO_nb.png');

  /// File path: assets/images/PALETTE.png
  AssetGenImage get palette => const AssetGenImage('assets/images/PALETTE.png');

  /// File path: assets/images/bandcamp.png
  AssetGenImage get bandcamp =>
      const AssetGenImage('assets/images/bandcamp.png');

  /// File path: assets/images/facebook.png
  AssetGenImage get facebook =>
      const AssetGenImage('assets/images/facebook.png');

  /// File path: assets/images/instagram.png
  AssetGenImage get instagram =>
      const AssetGenImage('assets/images/instagram.png');

  /// File path: assets/images/merch.png
  AssetGenImage get merch => const AssetGenImage('assets/images/merch.png');

  /// File path: assets/images/mixcloud.png
  AssetGenImage get mixcloud =>
      const AssetGenImage('assets/images/mixcloud.png');

  /// File path: assets/images/ra.png
  AssetGenImage get ra => const AssetGenImage('assets/images/ra.png');

  /// File path: assets/images/soundcloud.png
  AssetGenImage get soundcloud =>
      const AssetGenImage('assets/images/soundcloud.png');

  /// File path: assets/images/subside2025_ldscarla-0745.jpg
  AssetGenImage get subside2025Ldscarla0745 =>
      const AssetGenImage('assets/images/subside2025_ldscarla-0745.jpg');

  /// File path: assets/images/subside2025_ldscarla-0950.jpg
  AssetGenImage get subside2025Ldscarla0950 =>
      const AssetGenImage('assets/images/subside2025_ldscarla-0950.jpg');

  /// File path: assets/images/ticket.png
  AssetGenImage get ticket => const AssetGenImage('assets/images/ticket.png');

  /// File path: assets/images/twosidesgif.gif
  AssetGenImage get twosidesgif =>
      const AssetGenImage('assets/images/twosidesgif.gif');

  /// File path: assets/images/twosidesgif2.gif
  AssetGenImage get twosidesgif2 =>
      const AssetGenImage('assets/images/twosidesgif2.gif');

  /// File path: assets/images/website.png
  AssetGenImage get website => const AssetGenImage('assets/images/website.png');

  /// File path: assets/images/youtube.png
  AssetGenImage get youtube => const AssetGenImage('assets/images/youtube.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        logo2sides,
        lOGO2sidesEnvent,
        lOGONb,
        palette,
        bandcamp,
        facebook,
        instagram,
        merch,
        mixcloud,
        ra,
        soundcloud,
        subside2025Ldscarla0745,
        subside2025Ldscarla0950,
        ticket,
        twosidesgif,
        twosidesgif2,
        website,
        youtube
      ];
}

class Assets {
  const Assets._();

  static const String aEnv = '.env';
  static const $AssetsImagesGen images = $AssetsImagesGen();

  /// List of all assets
  static List<String> get values => [aEnv];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
