import 'package:flutter/material.dart';
import 'package:sportspotter/search_page.dart';


class NavigationWidget extends StatefulWidget {
  @override
  _NavigationWidgetState createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
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
                        setState(() {
                          _selectedIndex = 3;
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          height: 85,
                          child: Stack(
                              children: <Widget>[
                                Align(
                                    heightFactor: 2,
                                    child: Image.asset(
                                        'assets/icons/profile.png',
                                      color: _selectedIndex == 3
                                          ? const Color.fromRGBO(94, 97, 115, 1)
                                          : const Color.fromRGBO(94, 97, 115, 0.5)
                                    )
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    heightFactor: 5,
                                    child: Text('Profile', textAlign: TextAlign.left, style: TextStyle(
                                        color: _selectedIndex == 3
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
                        setState(() {
                          _selectedIndex = 2;
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          height: 85,
                          child: Stack(
                              children: <Widget>[
                                Align(
                                  heightFactor: 2,
                                    child: Image.asset(
                                      'assets/icons/favorites.png',
                                      color: _selectedIndex == 2
                                          ? const Color.fromRGBO(94, 97, 115, 1)
                                          : const Color.fromRGBO(94, 97, 115, 0.5)
                                    )
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    heightFactor: 5,
                                    child: Text('Favourites', textAlign: TextAlign.left, style: TextStyle(
                                        color: _selectedIndex == 2
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
                        setState(() {
                          _selectedIndex = 1;
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          height: 85,
                          child: Stack(
                              children: <Widget>[
                                Align(
                                    heightFactor: 2,
                                    child: Image.asset(
                                        'assets/icons/search.png',
                                      color: _selectedIndex == 1
                                          ? const Color.fromRGBO(94, 97, 115, 1)
                                          : const Color.fromRGBO(94, 97, 115, 0.5)
                                    )
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    heightFactor: 5,
                                    child: Text('Search', textAlign: TextAlign.left, style: TextStyle(
                                        color: _selectedIndex == 1
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
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width / 4,
                        height: 85,
                        child: Stack(
                            children: <Widget>[
                              Align(
                                heightFactor: 2,
                                  child: Image.asset(
                                      'assets/icons/home.png',
                                    color: _selectedIndex == 0
                                        ? const Color.fromRGBO(94, 97, 115, 1)
                                        : const Color.fromRGBO(94, 97, 115, 0.5)
                                  )
                              ),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  heightFactor: 5,
                                  child: Text('Home', textAlign: TextAlign.center, style: TextStyle(
                                      color: _selectedIndex == 0
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
