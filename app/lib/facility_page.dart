import 'package:flutter/material.dart';
import 'package:sportspotter/navigation.dart';

import 'models/facility.dart';

class FacilityPage extends StatefulWidget {
  final Facility facility;

  const FacilityPage({Key? key, required this.facility}) : super(key: key);

  @override
  _FacilityPageState createState() => _FacilityPageState();
}

class _FacilityPageState extends State<FacilityPage> {
  @override
  Widget build(BuildContext context) {
    //final double averageRating = getAverageRating();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          size: 40,
          color: Colors.black
        ),
        backgroundColor: const Color(0x00fdfdfd),
        elevation: 0,
        /*actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 10),
            icon: const Icon(
              Icons.star_outline,
            ),
            onPressed: () {

            },
          )
        ],*/
      ),
      body: Stack(
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (widget.facility.photo == "") ?
                  Image.asset(
                    'assets/images/error-image-generic.png',
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    fit: BoxFit.cover,
                  ) : Image.network(
                  widget.facility.photo,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Text(
                  widget.facility.name,
                  style: const TextStyle(
                    color: Color.fromRGBO(94, 97, 115, 1),
                    fontSize: 35
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis
                ),
                Container(
                  padding: const EdgeInsets.only(left: 5),
                  /*child: Row(
                    children: [
                      Text(
                        averageRating == -1 ? "No Reviews" : averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      if (averageRating != -1)
                        for (int i = 1; i <= averageRating.round(); i++)
                          const Icon(Icons.star),
                        for (int i = 5; i > averageRating.round(); i--)
                          const Icon(Icons.star_outline),
                    ],
                  ),*/
                ),
                Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                              children: [
                                for (int i = 0; i < widget.facility.tags.length; i++)
                                  Container(
                                      width: 90,
                                      height: 22,
                                      margin: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        borderRadius : BorderRadius.all(Radius.circular(5)),
                                        color : Color.fromRGBO(217, 217, 217, 1),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        widget.facility.tags[i].name,
                                        style: const TextStyle(fontSize: 13),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                  ),
                              ]
                          ),
                          /*Row(
                            children: [
                              for (int i = 0; i < 5; i++)
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      i == 0 ? 10 : 4, 4, i == 4 ? 15 : 4 , 4),
                                  child: const Icon(
                                    Icons.star_outline,
                                    size: 40,
                                  ),
                                ),
                              /*
                              Container(
                                  width: 130,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    border : Border.all(
                                        color: const Color.fromRGBO(94, 97, 115, 1),
                                        width: 3
                                    ),
                                    color : const Color.fromRGBO(217, 217, 217, 1),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Review",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),
                                  )
                              ),*/
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.all(7),
                            child: const Text(
                              "Reviews:",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          for (int i = 0; i < 10; i++)
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 35),
                            child: Row(
                              children: [
                                Image.asset(
                                    'assets/icons/profile.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.fill,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    children: const [
                                      Text("a"),
                                      Text("b"),
                                      Text("c")
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),*/
                          const SizedBox(height: 100)
                        ],
                      )
                  ),
                )
              ]
          ),
          const Positioned(
              bottom: 0,
              left: 0,
              child: NavigationWidget(selectedIndex: 4)
          ),
        ]
      )
    );
  }
/*
  double getAverageRating(){
    if (widget.facility.ratings.isEmpty) {
      return -1;
    }
    double sum = 0;
    for (double rating in widget.facility.ratings) {
      sum += rating;
    }
    return sum / widget.facility.ratings.length;
  }*/
}
