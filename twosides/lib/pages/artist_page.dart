import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twosides/http/download_file.dart';
import 'package:twosides/models/artist.dart';
import 'package:twosides/models/link.dart';
import 'package:twosides/models/asset.dart';
import 'package:twosides/twosides_provider.dart';
import 'package:twosides/pages/artist_page_state_model.dart';
import 'package:twosides/constants/colors.dart';
import 'package:twosides/constants/routes.dart';
import 'package:twosides/gen/assets.gen.dart';
import 'package:twosides/widgets/page_headers.dart';
import 'package:twosides/widgets/page_footer.dart';
import 'package:twosides/widgets/horizontal_carousel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/env.dart';

final String imageUrl = Env.imageUrl;

class LinkIconButton extends StatelessWidget {
  const LinkIconButton({super.key, required this.link});
  final Link link;

  @override
  Widget build(BuildContext context) {
    String _image = "";
    Uri _url = Uri.parse(link.url);

    if (link.type == LinkType.website) {
      _image = Assets.images.websiteUiWebSvgrepoCom;
    } else if (link.type == LinkType.merch) {
      _image = Assets.images.websiteUiWebSvgrepoCom;
    } else if (link.type == LinkType.instagram) {
      _image = Assets.images.instagramSvgrepoCom;
    } else if (link.type == LinkType.facebook) {
      _image = Assets.images.facebookSvgrepoCom;
    } else if (link.type == LinkType.youtube) {
      _image = Assets.images.youtubeRoundSvgrepoCom;
    } else if (link.type == LinkType.soundcloud) {
      _image = Assets.images.soundcloudRoundSvgrepoCom;
    } else if (link.type == LinkType.bandcamp) {
      _image = Assets.images.bandcampLogoSvgrepoCom;
    } else if (link.type == LinkType.mixcloud) {
      _image = Assets.images.mixcloudSvgrepoCom;
    } else if (link.type == LinkType.ticketing) {
      _image = Assets.images.websiteUiWebSvgrepoCom;
    } else if (link.type == LinkType.ra) {
      _image = Assets.images.raSvg;
    } else if (link.type == LinkType.live || link.type == LinkType.release) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Container(
        height: 40,
        width: 40,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
              onTap: () async {
                goToUrl(_url);
              },
              child: SvgPicture.asset(_image)),
        ),
      ),
    );
  }
}

//
class LinkIcons extends StatefulWidget {
  const LinkIcons({super.key, required this.links});
  final List<Link> links;

  @override
  State<LinkIcons> createState() => _LinkIconsState();
}

class _LinkIconsState extends State<LinkIcons> {
  List<Widget> iconWidgets = [];

  @override
  Widget build(BuildContext context) {
    iconWidgets = [];
    for (final link in widget.links) {
      if (link.type != LinkType.live && link.type != LinkType.release) {
        iconWidgets.add(LinkIconButton(link: link));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: iconWidgets,
    );
  }
}

//
class ArtistPicture extends StatefulWidget {
  const ArtistPicture({super.key, required this.assetId});
  final String assetId;

  @override
  State<ArtistPicture> createState() => _ArtistPictureState();
}

class _ArtistPictureState extends State<ArtistPicture> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      alignment: Alignment.center,
      child: Image.network(
        '$imageUrl/asset/${widget.assetId}',
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
              child: CircularProgressIndicator(
            color: TwoSidesColors.primaryColor,
          ));
        },
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
      ),
    );
  }
}

//
class ArtistGridInfo extends StatefulWidget {
  const ArtistGridInfo({super.key, required this.artist});
  final Artist artist;

  @override
  State<ArtistGridInfo> createState() => _ArtistGridInfoState();
}

class _ArtistGridInfoState extends State<ArtistGridInfo> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.06,
      child: Row(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.width / 3,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1, color: TwoSidesColors.textColor),
            ),
          ),
          child: LinkIcons(links: widget.artist.links!),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.width / 3,
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(width: 1, color: TwoSidesColors.textColor),
              right: BorderSide(width: 1, color: TwoSidesColors.textColor),
              bottom: BorderSide(width: 1, color: TwoSidesColors.textColor),
            ),
          ),
          child: Center(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                  child: const Text("Booker l'artiste"),
                  onTap: () async {
                    final emailUri = Uri.parse(
                        'mailto:${"2sidesbooking@gmail.com"}?subject=Booking ${widget.artist.name}');
                    await launchUrl(emailUri);
                  }),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.width / 3,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1, color: TwoSidesColors.textColor),
            ),
          ),
          child: Center(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                  child: Text("PressKit - ${widget.artist.name}"),
                  onTap: () async {
                    downloadFile(
                        widget.artist.assets!
                            .firstWhere(
                                (asset) => asset.role == AssetRole.presskit)
                            .id,
                        widget.artist.name);
                  }),
            ),
          ),
        ),
      ]),
    );
  }
}

//
class ArtistBioSection extends StatefulWidget {
  const ArtistBioSection({super.key, required this.artist});
  final Artist artist;

  @override
  State<ArtistBioSection> createState() => _ArtistBioSectionState();
}

class _ArtistBioSectionState extends State<ArtistBioSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "BIO",
                      style: TextStyle(
                        color: TwoSidesColors.primaryColor,
                        fontFamily: 'Boldonse',
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        //height: 0.9,
                      ),
                    ),
                    Text(
                      widget.artist.location!,
                      style: const TextStyle(
                        color: TwoSidesColors.primaryColor,
                        fontFamily: 'Boldonse',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        //height: 0.9,
                      ),
                    ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  widget.artist.description!,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    color: TwoSidesColors.textColor,
                    fontFamily: 'Prophet',
                    fontSize: 17,
                    //fontWeight: FontWeight.bold,
                    //height: 0.9,
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}

class ArtistLiveSection extends StatefulWidget {
  const ArtistLiveSection({super.key, required this.artist});
  final Artist artist;

  @override
  State<ArtistLiveSection> createState() => _ArtistLiveSectionState();
}

class _ArtistLiveSectionState extends State<ArtistLiveSection> {
  @override
  Widget build(BuildContext context) {
    final List<CarouselItem> items = [];
    int number_live = 0;
    if (widget.artist.links!.any((link) => link.type == LinkType.live)) {
      widget.artist.links!.forEach((link) {
        if (link.type == LinkType.live) {
          items.add(CarouselItem(index: number_live, iframe: link.url));
          number_live++;
        }
      });
      return Column(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.5,
          child: const Align(
            alignment: Alignment.centerRight,
            child: Text(
              "LIVE / PODCAST",
              style: TextStyle(
                color: TwoSidesColors.primaryColor,
                fontFamily: 'Boldonse',
                fontSize: 50,
                fontWeight: FontWeight.bold,
                //height: 0.9,
              ),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.20,
          width: MediaQuery.of(context).size.width,
          child: Stack(alignment: AlignmentDirectional.center, children: [
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              alignment: Alignment.center,
              child: HorizontalCarousel(
                  items: items,
                  itemWidth: MediaQuery.of(context).size.width * 0.25),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width / 4,
              child: Container(
                color: TwoSidesColors.backgroundColor,
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width / 4,
              child: Container(
                color: TwoSidesColors.backgroundColor,
              ),
            ),
          ]),
        )
      ]);
    } else {
      return Container();
    }
  }
}

class ArtistReleaseSection extends StatefulWidget {
  const ArtistReleaseSection({super.key, required this.artist});
  final Artist artist;

  @override
  State<ArtistReleaseSection> createState() => _ArtistReleaseSectionState();
}

class _ArtistReleaseSectionState extends State<ArtistReleaseSection> {
  @override
  Widget build(BuildContext context) {
    final List<CarouselItem> items = [];
    int number_release = 0;
    if (widget.artist.links!.any((link) => link.type == LinkType.release)) {
      widget.artist.links!.forEach((link) {
        if (link.type == LinkType.release) {
          items.add(CarouselItem(index: number_release, iframe: link.url));
          number_release++;
        }
      });
      return Column(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.5,
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "RELEASE",
              style: TextStyle(
                color: TwoSidesColors.primaryColor,
                fontFamily: 'Boldonse',
                fontSize: 50,
                fontWeight: FontWeight.bold,
                //height: 0.9,
              ),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.20,
          width: MediaQuery.of(context).size.width,
          child: Stack(alignment: AlignmentDirectional.center, children: [
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              alignment: Alignment.center,
              child: HorizontalCarousel(
                  items: items,
                  itemWidth: MediaQuery.of(context).size.width * 0.25),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width / 4,
              child: Container(
                color: TwoSidesColors.backgroundColor,
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width / 4,
              child: Container(
                color: TwoSidesColors.backgroundColor,
              ),
            ),
          ]),
        )
      ]);
    } else {
      return Container();
    }
  }
}

//
class ArtistNameButton extends StatefulWidget {
  const ArtistNameButton({super.key, this.artist});
  final Artist? artist;

  @override
  State<ArtistNameButton> createState() => _ArtistNameButtonState();
}

class _ArtistNameButtonState extends State<ArtistNameButton> {
  bool _isHovered = false;
  Color _hoverColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    if (widget.artist != null) {
      _hoverColor = widget.artist!.style == "Dub"
          ? TwoSidesColors.primaryColor
          : TwoSidesColors.secondaryColor;
      return Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
                context, '${RoutingPageNames.artist}/${widget.artist!.id}');
          },
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: AnimatedOpacity(
              opacity: _isHovered ? 1.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                widget.artist!.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _isHovered ? _hoverColor : TwoSidesColors.textColor,
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      _hoverColor = TwoSidesColors.primaryColor;
      return Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '${RoutingPageNames.booking}');
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: AnimatedOpacity(
              opacity: _isHovered ? 1.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                "All",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _isHovered ? _hoverColor : TwoSidesColors.textColor,
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

//
class ArtistsListSection extends ConsumerWidget {
  ArtistsListSection({super.key, required this.artists});
  final List<Artist> artists;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> artistsWidgetList = [];

    for (final artist in artists) {
      artistsWidgetList.add(ArtistNameButton(artist: artist));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Wrap(
          spacing: 8, // horizontal spacing
          runSpacing: 16, // vertical spacing
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6 / 6 - 8,
              child: const ArtistNameButton(),
            ),
            for (final artist in artists)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6 / 6 - 8,
                child: ArtistNameButton(artist: artist),
              ),
          ],
        ),
      ),
    );
  }
}

//
class ArtistBody extends StatefulWidget {
  const ArtistBody({super.key, required this.artist});
  final Artist artist;

  @override
  State<ArtistBody> createState() => _ArtistBodyState();
}

class _ArtistBodyState extends State<ArtistBody> {
  String _assetId = "0";

  @override
  Widget build(BuildContext context) {
    if (widget.artist.assets != null) {
      int assetIndexId = widget.artist.assets!
          .indexWhere((asset) => asset.role == AssetRole.primary);
      _assetId = widget.artist.assets![assetIndexId].id.toString();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ArtistPicture(assetId: _assetId),
        ArtistGridInfo(artist: widget.artist),
        ArtistBioSection(artist: widget.artist),
        ArtistLiveSection(artist: widget.artist),
        ArtistReleaseSection(artist: widget.artist),
      ],
    );
  }
}

class ArtistPage extends ConsumerWidget {
  ArtistPage({super.key, required this.artistId});
  final int artistId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistPageViewState =
        ref.watch(artistPageViewModelProvider(artistId));

    return Scaffold(
        backgroundColor: TwoSidesColors.backgroundColor,
        body: Stack(children: [
          Column(children: [
            //Container(
            //  height: MediaQuery.of(context).size.height * 0.1,
            //),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: artistPageViewState.artist.when(
                data: (_) => artistPageViewState.artists.when(
                  data: (_) => LayoutBuilder(builder: (BuildContext context,
                      BoxConstraints viewportConstraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: viewportConstraints.maxHeight),
                          child: Builder(builder: (context) {
                            return Column(children: [
                              ArtistBody(
                                  artist: artistPageViewState.artist.value!),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 100, 0, 80),
                                child: ArtistsListSection(
                                    artists:
                                        artistPageViewState.artists.value!),
                              ),
                              const PageFooter(),
                            ]);
                          })),
                    );
                  }),
                  error: (error, stacktrace) {
                    return Column(children: [
                      Text(error.toString()),
                      Text(stacktrace.toString())
                    ]);
                  },
                  loading: () => Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: TwoSidesColors.backgroundColor,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: TwoSidesColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                error: (error, stacktrace) {
                  return Column(children: [
                    Text(error.toString()),
                    Text(stacktrace.toString())
                  ]);
                },
                loading: () => Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: TwoSidesColors.backgroundColor,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: TwoSidesColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ]),
          const ArtistPageHeader(),
        ]));
  }
}
