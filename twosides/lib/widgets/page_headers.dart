import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twosides/models/artist.dart';
import 'package:twosides/twosides_provider.dart';
import 'package:twosides/pages/booking_page_state_model.dart';
import 'package:twosides/constants/colors.dart';
import 'package:twosides/constants/routes.dart';
import 'package:twosides/gen/assets.gen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class MenuDropDown extends StatefulWidget {
  const MenuDropDown({super.key, required this.currentPage});
  final String currentPage;

  @override
  State<MenuDropDown> createState() => _MenuDropDownState();
}

class _MenuDropDownState extends State<MenuDropDown> {
  SampleItem _dropdownvalue = SampleItem.itemTwo;
  var _items = ['2Sides', 'Booking', 'About'];
  //var _routes = [
  //  '2Sides',
  //  'Booking',
  //  'About',
  //];

  @override
  Widget build(BuildContext context) {
    switch (widget.currentPage) {
      case "Booking":
        _dropdownvalue = SampleItem.itemTwo;
        break;
      case "About":
        _dropdownvalue = SampleItem.itemThree;
        break;
    }
    ;

    return PopupMenuButton<SampleItem>(
      icon: const Icon(Icons.menu, size: 50),
      initialValue: _dropdownvalue,
      onSelected: (SampleItem item) {
        setState(() {
          _dropdownvalue = item;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        PopupMenuItem<SampleItem>(
            value: SampleItem.itemOne, child: Text(_items[0])),
        PopupMenuItem<SampleItem>(
            value: SampleItem.itemTwo, child: Text(_items[1])),
        PopupMenuItem<SampleItem>(
            value: SampleItem.itemThree, child: Text(_items[2])),
      ],
    );
  }
}

class BookingPageHeader extends ConsumerWidget {
  const BookingPageHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.12,
      color: Colors.black,
      child: Row(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "BOOKING",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Prophet',
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    height: 0.9,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      "2sidesbooking@gmail.com",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'NeueMetanaNext',
                        fontSize: 20,
                        height: 0.9,
                      ),
                    )),
              ]),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IntrinsicWidth(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedUnderlineButtonSmallBlack(
                          text: "BOOKING", route: RoutingPageNames.booking),
                    ],
                  ),
                ),
                IntrinsicWidth(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedUnderlineButtonSmallBlack(
                          text: "PROD EVENT", route: RoutingPageNames.prod),
                    ],
                  ),
                ),
                IntrinsicWidth(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedUnderlineButtonSmallBlack(
                          text: "ADMIN", route: RoutingPageNames.admin),
                    ],
                  ),
                ),
                IntrinsicWidth(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedUnderlineButtonSmallBlack(
                          text: "ABOUT", route: RoutingPageNames.about),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class AboutPageHeader extends ConsumerWidget {
  const AboutPageHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.12,
      child: Row(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              "ABOUT",
              style: TextStyle(
                color: TwoSidesColors.textColor,
                fontFamily: 'Prophet',
                fontSize: 110,
                fontWeight: FontWeight.bold,
                height: 0.9,
              ),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                0, 0, MediaQuery.of(context).size.width * 0.05, 0),
            child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IntrinsicWidth(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedUnderlineButtonSmall(
                            text: "BOOKING", route: RoutingPageNames.booking),
                      ],
                    ),
                  ),
                  IntrinsicWidth(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedUnderlineButtonSmall(
                            text: "PROD EVENT", route: RoutingPageNames.prod),
                      ],
                    ),
                  ),
                  IntrinsicWidth(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedUnderlineButtonSmall(
                            text: "ADMIN", route: RoutingPageNames.admin),
                      ],
                    ),
                  ),
                  IntrinsicWidth(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedUnderlineButtonSmall(
                            text: "ABOUT", route: RoutingPageNames.about),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ]),
    );
  }
}

class ProdEventPageHeader extends ConsumerWidget {
  const ProdEventPageHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.12,
      child: Row(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              "PROD. EVENT",
              style: TextStyle(
                color: TwoSidesColors.textColor,
                fontFamily: 'Prophet',
                fontSize: 110,
                fontWeight: FontWeight.bold,
                height: 0.9,
              ),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                0, 0, MediaQuery.of(context).size.width * 0.05, 0),
            child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IntrinsicWidth(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedUnderlineButtonSmall(
                            text: "BOOKING", route: RoutingPageNames.booking),
                      ],
                    ),
                  ),
                  IntrinsicWidth(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedUnderlineButtonSmall(
                            text: "PROD EVENT", route: RoutingPageNames.prod),
                      ],
                    ),
                  ),
                  IntrinsicWidth(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedUnderlineButtonSmall(
                            text: "ADMIN", route: RoutingPageNames.admin),
                      ],
                    ),
                  ),
                  IntrinsicWidth(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedUnderlineButtonSmall(
                            text: "ABOUT", route: RoutingPageNames.about),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ]),
    );
  }
}

class AdminOrgPageHeader extends ConsumerWidget {
  const AdminOrgPageHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.12,
      child: Row(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              "PROD. EVENT",
              style: TextStyle(
                color: TwoSidesColors.textColor,
                fontFamily: 'Prophet',
                fontSize: 110,
                fontWeight: FontWeight.bold,
                height: 0.9,
              ),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                0, 0, MediaQuery.of(context).size.width * 0.05, 0),
            child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IntrinsicWidth(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedUnderlineButtonSmall(
                            text: "BOOKING", route: RoutingPageNames.booking),
                      ],
                    ),
                  ),
                  IntrinsicWidth(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedUnderlineButtonSmall(
                            text: "PROD EVENT", route: RoutingPageNames.prod),
                      ],
                    ),
                  ),
                  IntrinsicWidth(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedUnderlineButtonSmall(
                            text: "ADMIN", route: RoutingPageNames.admin),
                      ],
                    ),
                  ),
                  IntrinsicWidth(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedUnderlineButtonSmall(
                            text: "ABOUT", route: RoutingPageNames.about),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ]),
    );
  }
}

class AnimatedUnderlineButtonSmallBlack extends StatefulWidget {
  const AnimatedUnderlineButtonSmallBlack(
      {super.key, required this.text, required this.route});
  final String text;
  final String route;

  @override
  State<AnimatedUnderlineButtonSmallBlack> createState() =>
      _AnimatedUnderlineButtonSmallBlackState();
}

class _AnimatedUnderlineButtonSmallBlackState
    extends State<AnimatedUnderlineButtonSmallBlack> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, widget.route);
            },
            child: Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Boldonse',
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Animated underline
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            height: 3,
            //width: _hovered ? 140 : 0, // animate left → right
            decoration: BoxDecoration(
              color: _hovered
                  ? TwoSidesColors.primaryColor
                  : TwoSidesColors.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedUnderlineButtonSmall extends StatefulWidget {
  const AnimatedUnderlineButtonSmall(
      {super.key, required this.text, required this.route});
  final String text;
  final String route;

  @override
  State<AnimatedUnderlineButtonSmall> createState() =>
      _AnimatedUnderlineButtonSmallState();
}

class _AnimatedUnderlineButtonSmallState
    extends State<AnimatedUnderlineButtonSmall> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, widget.route);
            },
            child: Text(
              widget.text,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Boldonse',
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Animated underline
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            height: 3,
            //width: _hovered ? 140 : 0, // animate left → right
            decoration: BoxDecoration(
              color: _hovered
                  ? TwoSidesColors.primaryColor
                  : TwoSidesColors.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedUnderlineButton extends StatefulWidget {
  const AnimatedUnderlineButton(
      {super.key, required this.text, required this.route});
  final String text;
  final String route;

  @override
  State<AnimatedUnderlineButton> createState() =>
      _AnimatedUnderlineButtonState();
}

class _AnimatedUnderlineButtonState extends State<AnimatedUnderlineButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, widget.route);
            },
            child: Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Boldonse',
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Animated underline
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            height: 3,
            //width: _hovered ? 140 : 0, // animate left → right
            decoration: BoxDecoration(
              color: _hovered
                  ? TwoSidesColors.primaryColor
                  : TwoSidesColors.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class HomePageHeader extends ConsumerWidget {
  const HomePageHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      color: Colors.black.withOpacity(0.8),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IntrinsicWidth(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedUnderlineButton(
                        text: "BOOKING", route: RoutingPageNames.booking),
                  ],
                ),
              ),
              IntrinsicWidth(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedUnderlineButton(
                        text: "PROD EVENT", route: RoutingPageNames.prod),
                  ],
                ),
              ),
              IntrinsicWidth(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedUnderlineButton(
                        text: "ADMIN", route: RoutingPageNames.admin),
                  ],
                ),
              ),
              IntrinsicWidth(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedUnderlineButton(
                        text: "ABOUT", route: RoutingPageNames.about),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArtistPageHeader extends ConsumerWidget {
  const ArtistPageHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      color: TwoSidesColors.backgroundColor,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Center(
              child: Image.asset(
                scale: 9,
                Assets.images.lOGO2sidesEnvent.path,
              ),
            )),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IntrinsicWidth(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedUnderlineButtonSmall(
                          text: "BOOKING", route: RoutingPageNames.booking),
                    ],
                  ),
                ),
                IntrinsicWidth(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedUnderlineButtonSmall(
                          text: "PROD EVENT", route: RoutingPageNames.prod),
                    ],
                  ),
                ),
                IntrinsicWidth(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedUnderlineButtonSmall(
                          text: "ADMIN", route: RoutingPageNames.admin),
                    ],
                  ),
                ),
                IntrinsicWidth(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedUnderlineButtonSmall(
                          text: "ABOUT", route: RoutingPageNames.about),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
