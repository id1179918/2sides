import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twosides/models/artist.dart';
import 'package:twosides/models/asset.dart';
import 'package:twosides/twosides_provider.dart';
import 'package:twosides/pages/booking_page_state_model.dart';
import 'package:twosides/pages/artist_page.dart';
import 'package:twosides/constants/colors.dart';
import 'package:twosides/gen/assets.gen.dart';
import 'package:twosides/widgets/page_headers.dart';
import 'package:twosides/widgets/page_footer.dart';
import 'package:twosides/constants/routes.dart';
import 'package:twosides/asset_image_cache.dart';

import '../constants/env.dart';

final String imageUrl = Env.imageUrl;

class BlurImageOnLoad extends StatefulWidget {
  const BlurImageOnLoad({super.key});

  @override
  State<BlurImageOnLoad> createState() => _BlurImageOnLoadState();
}

class _BlurImageOnLoadState extends State<BlurImageOnLoad> {
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          scale: 3,
          Assets.images.lOGO2sidesEnvent.path,
        ),
        if (!_loaded)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(color: Colors.transparent),
            ),
          ),
        Image.asset(
          scale: 3,
          Assets.images.lOGO2sidesEnvent.path,
          frameBuilder: (_, child, frame, __) {
            if (frame != null) {
              Future.microtask(() => setState(() => _loaded = true));
            }
            return AnimatedOpacity(
              opacity: _loaded ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: child,
            );
          },
        ),
      ],
    );
  }
}

class ArtistTile extends StatefulWidget {
  ArtistTile({super.key, required this.artist});
  final Artist artist;

  @override
  State<ArtistTile> createState() => _ArtistTileState();
}

class _ArtistTileState extends State<ArtistTile> {
  bool _isHovered = false;
  Color _hoverColor = Colors.transparent;
  int? _assetId = 0;
  Uint8List? _imageBytes;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    final assets = widget.artist.assets;
    if (assets != null && assets.isNotEmpty) {
      final index =
          assets.indexWhere((asset) => asset.role == AssetRole.primary);

      if (index != -1) {
        _assetId = assets[index].id;
      }
    }

    if (_assetId != null) {
      _loadImage();
    } else {
      _loading = false;
      _error = true;
    }
  }

  Future<void> _loadImage() async {
    if (_assetId == null) {
      log("assetId == null");
      setState(() {
        _loading = false;
        _error = true;
      });
      return;
    }

    final cached = AssetImageCache.get(_assetId!);
    if (cached != null) {
      setState(() {
        _imageBytes = cached;
        _loading = false;
      });
      return;
    }

    try {
      final bytes = await fetchAssetBytes(_assetId!);
      AssetImageCache.put(_assetId!, bytes);

      setState(() {
        _imageBytes = bytes;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Widget _buildImage() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: TwoSidesColors.primaryColor,
        ),
      );
    }

    if (_error || _imageBytes == null) {
      return const Icon(Icons.broken_image, size: 48);
    }

    return Image.memory(
      _imageBytes!,
      fit: BoxFit.cover,
      gaplessPlayback: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    _hoverColor = widget.artist.style == "Dub"
        ? TwoSidesColors.primaryColor.withValues(alpha: 0.3)
        : TwoSidesColors.secondaryColor.withValues(alpha: 0.8);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
            context, '${RoutingPageNames.artist}/${widget.artist.id}');
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildImage(),
            AnimatedOpacity(
              opacity: _isHovered ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: Container(
                color: _hoverColor,
              ),
            ),
            Center(
              child: AnimatedOpacity(
                opacity: _isHovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: AnimatedSlide(
                  offset: _isHovered ? Offset.zero : const Offset(0, 0.1),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  child: Text(
                    widget.artist.name.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Boldonse',
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black54,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingPage extends ConsumerWidget {
  BookingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingPageViewState = ref.watch(bookingPageViewModelProvider);

    return bookingPageViewState.artists.when(
      data: (_) {
        return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: BookingPageHeader(),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  delegate: SliverChildBuilderDelegate(
                      childCount: bookingPageViewState.artists.value!.length,
                      (context, index) {
                    return ArtistTile(
                        artist: bookingPageViewState.artists.value![index]);
                  }),
                ),
              ),
              SliverToBoxAdapter(
                child: PageFooter(),
              ),
            ],
          ),
        );
      },
      error: (error, stacktrace) {
        return Column(
            children: [Text(error.toString()), Text(stacktrace.toString())]);
      },
      loading: () => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: TwoSidesColors.backgroundColor,
        child: Center(
          child: BlurImageOnLoad(),
        ),
      ),
    );
  }
}
