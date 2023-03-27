import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sportspotter/facility_page.dart';
import 'package:sportspotter/favourites.dart';
import 'package:sportspotter/main.dart';
import 'package:sportspotter/models/data_service.dart';
import 'package:sportspotter/models/facility.dart';
import 'package:sportspotter/models/review.dart';
import 'package:sportspotter/models/tag.dart';
import 'package:sportspotter/profile.dart';
import 'package:sportspotter/search_page.dart';


class NavigationWidget extends StatefulWidget {
  final int selectedIndex;

  const NavigationWidget({Key? key, required this.selectedIndex}): super(key: key);

  @override
  _NavigationWidgetState createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 85,

        child: Stack(
            children: <Widget>[
              Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 85,
                      decoration: const BoxDecoration(
                        color : Color.fromRGBO(245, 245, 245, 1),
                      )
                  )
              ),Positioned(
                  left: MediaQuery.of(context).size.width / 4 * 3,
                  child: GestureDetector(
                      onTap: () {
                        if (widget.selectedIndex != 3) {
                          Navigator.push(context, PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) => const ProfileScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero));
                        }
                      },
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                          height: 85,
                          child: Stack(
                              children: <Widget>[
                                Align(
                                    heightFactor: 2,
                                    child: Image.asset(
                                        'assets/icons/profile.png',
                                      color: widget.selectedIndex == 3
                                          ? const Color.fromRGBO(94, 97, 115, 1)
                                          : const Color.fromRGBO(94, 97, 115, 0.5)
                                    )
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    heightFactor: 5,
                                    child: Text('Profile', textAlign: TextAlign.left, style: TextStyle(
                                        color: widget.selectedIndex == 3
                                            ? const Color.fromRGBO(94, 97, 115, 1)
                                            : const Color.fromRGBO(94, 97, 115, 0.5),
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1
                                    ),)
                                ),
                              ]
                          )
                      )
                  )
              ),Positioned(
                  left: MediaQuery.of(context).size.width / 4 * 2,
                  child: GestureDetector(
                      onTap: () {
                        if (widget.selectedIndex != 2) {
                            Navigator.push(context, PageRouteBuilder(
                                pageBuilder: (context, animation1, animation2) => const FavouritesScreen(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero));
                          }
                      },
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                          height: 85,
                          child: Stack(
                              children: <Widget>[
                                Align(
                                  heightFactor: 2,
                                    child: Image.asset(
                                      'assets/icons/favorites.png',
                                      color: widget.selectedIndex == 2
                                          ? const Color.fromRGBO(94, 97, 115, 1)
                                          : const Color.fromRGBO(94, 97, 115, 0.5)
                                    )
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    heightFactor: 5,
                                    child: Text('Favourites', textAlign: TextAlign.left, style: TextStyle(
                                        color: widget.selectedIndex == 2
                                            ? const Color.fromRGBO(94, 97, 115, 1)
                                            : const Color.fromRGBO(94, 97, 115, 0.5),
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1
                                    ),)
                                )
                              ]
                          )
                      )
                  )
              ), Positioned(
                  left: MediaQuery.of(context).size.width / 4 * 1,
                  child: GestureDetector(
                      onTap: () {
                        if (widget.selectedIndex != 1) {
                          Navigator.push(context, PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) => const SearchScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero));
                        }
                      },
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                          height: 85,
                          child: Stack(
                              children: <Widget>[
                                Align(
                                    heightFactor: 2,
                                    child: Image.asset(
                                        'assets/icons/search.png',
                                      color: widget.selectedIndex == 1
                                          ? const Color.fromRGBO(94, 97, 115, 1)
                                          : const Color.fromRGBO(94, 97, 115, 0.5)
                                    )
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    heightFactor: 5,
                                    child: Text('Search', textAlign: TextAlign.left, style: TextStyle(
                                        color: widget.selectedIndex == 1
                                            ? const Color.fromRGBO(94, 97, 115, 1)
                                            : const Color.fromRGBO(94, 97, 115, 0.5),
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1
                                    ),)
                                )
                              ]
                          )
                      )
                  )
              ),Positioned(
                left: 0,
                child: GestureDetector(
                    onTap: () {
                      if (widget.selectedIndex != 0) {
                        Navigator.push(context, PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) => const MyHomePage(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero));
                      }
                    },
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                        height: 85,
                        child: Stack(
                            children: <Widget>[
                              Align(
                                heightFactor: 2,
                                  child: Image.asset(
                                      'assets/icons/home.png',
                                    color: widget.selectedIndex == 0
                                        ? const Color.fromRGBO(94, 97, 115, 1)
                                        : const Color.fromRGBO(94, 97, 115, 0.5)
                                  )
                              ),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  heightFactor: 5,
                                  child: Text('Home', textAlign: TextAlign.center, style: TextStyle(
                                      color: widget.selectedIndex == 0
                                          ? const Color.fromRGBO(94, 97, 115, 1)
                                          : const Color.fromRGBO(94, 97, 115, 0.5),
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1
                                  ),)
                              ),
                            ]
                        )
                    )
                ),
              )
            ]
        )
    );
  }
}
