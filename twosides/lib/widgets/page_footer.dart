import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:twosides/constants/colors.dart';
import 'package:twosides/constants/routes.dart';
import 'package:twosides/gen/assets.gen.dart';

class PageFooter extends StatefulWidget {
  const PageFooter({super.key});

  @override
  State<PageFooter> createState() => _PageFooterState();
}

class _PageFooterState extends State<PageFooter> {
  final TextEditingController _emailController = TextEditingController(text: "Email");

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      color: TwoSidesColors.primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Image.asset(
              scale: 5,
              Assets.images.lOGO2sidesEnvent.path,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '${RoutingPageNames.booking}');
                    },
                    child: const Text(
                      'Booking',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'NeueMetanaNext',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 0.9,
                      ),
                  )),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: TextButton(
                    onPressed: null,
                    //() {
                    //  //Navigator.pushNamed(context, '${RoutingPageNames.booking}');
                    //},
                    child: const Text(
                      'Prod. Event',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'NeueMetanaNext',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 0.9,
                      ),
                  )),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: TextButton(
                    onPressed: null,
                    //() {
                    //  //Navigator.pushNamed(context, '${RoutingPageNames.booking}');
                    //},
                    child: const Text(
                      'Admin',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'NeueMetanaNext',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 0.9,
                      ),
                  )),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '${RoutingPageNames.about}');
                  },
                  child: const Text(
                    'About',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'NeueMetanaNext',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 0.9,
                    ),
                )),
              ]
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: const Text(
                      "Suivez nos news, concerts, releases et rejoignez notre newsletter",
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'NeueMetanaNext',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        height: 0.9,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder()
                              ),
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                         ElevatedButton(
                          onPressed: () async {},
                          style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              backgroundColor: TwoSidesColors.primaryColor,
                              minimumSize: const Size(10, 60)),
                          child: Text(
                            "S'abonner",
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'signika',
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                  Column(
                    children: [
                      const Text(
                        "ALL RIGHTS REVERVED",
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'signika',
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const Text(
                        "2026 ©",
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'signika',
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ]
                  ),
                ]
              ),
            ),
          ),
        ]
      ),
    );
  }
}