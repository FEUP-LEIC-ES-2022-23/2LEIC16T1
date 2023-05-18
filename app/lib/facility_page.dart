import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportspotter/models/data_service.dart';
import 'package:sportspotter/navigation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sportspotter/tools/rating.dart';
import 'package:sportspotter/tools/review.dart';

import 'models/facility.dart';

class FacilityPage extends StatefulWidget {
  final Facility facility;

  const FacilityPage({Key? key, required this.facility}) : super(key: key);

  @override
  _FacilityPageState createState() => _FacilityPageState();
}

class _FacilityPageState extends State<FacilityPage> {
  final TextEditingController reviewController = TextEditingController();
  Widget rating = CircularProgressIndicator();
  Widget myRating = CircularProgressIndicator();
  double? value = 0;
  double? myValue = 0;
  late List<ReviewData>? reviews;

  submitReview() async {
    final user = FirebaseAuth.instance.currentUser;
    final description = reviewController.text;
    if (description.isNotEmpty) {
      await addReview(widget.facility.id, user!.uid, description);
      reviewController.clear();
      setState(() {});
    }
  }

  Future<void> getReviews() async {
    List<dynamic>? aux = await getFacilityReviews(widget.facility.id);
    for (int i = 0; i < aux.length; i++) {
      final user = await FirebaseFirestore.instance
          .collection('user')
          .doc(aux[i]['userID'])
          .get();
      aux[i]['user'] = user['firstName'] + ' ' + user['lastName'] + '(' + user['username'] + ')';
      aux[i]['date'] = DateTime.fromMillisecondsSinceEpoch(aux[i]['date'].seconds * 1000);

    }



  buildRating() async {
    value = await getFacilityRating(widget.facility.id);
    final user = FirebaseAuth.instance.currentUser;
    bool loggedIn = user != null;
    if (loggedIn) {
      myValue = await getUserRating(user.uid, widget.facility.id);
      myValue ??= 0;
    }
     value ??= 0;
      rating = RatingBar(
        ignoreGestures: true,
        initialRating: value!,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        ratingWidget: RatingWidget(
          full: const Icon(Icons.star, color: Colors.amber),
          half: const Icon(Icons.star_half, color: Colors.amber),
          empty: const Icon(Icons.star_outline, color: Colors.amber),
        ),
        itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
        onRatingUpdate: (rating) {},
      );
      if (loggedIn) {
        myRating = RatingBar(
          initialRating: myValue!,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          ratingWidget: RatingWidget(
            full: const Icon(Icons.star, color: Colors.amber),
            half: const Icon(Icons.star_half, color: Colors.amber),
            empty: const Icon(Icons.star_outline, color: Colors.amber),
          ),
          itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
          onRatingUpdate: (rating) async {
            await addRating(widget.facility.id, user.uid, rating);
            setState(() {});
          }
        );
      } else {
        myRating = Text(
          "Log in to rate this facility",
          style: TextStyle(fontSize: 20, color: Colors.grey),
        );
      }

  }

  @override
  Widget build(BuildContext context) {
    //final double averageRating = getAverageRating();
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(size: 40, color: Colors.black),
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
        body: FutureBuilder(
          future:  buildRating(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Stack(children: [
              ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  (widget.facility.photo == "")
                      ? Image.asset(
                          'assets/images/error-image-generic.png',
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          widget.facility.photo,
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                  Row(
                    children: [
                      Text(value.toString(),
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          )),
                      rating,
                    ],
                  ),
                  Text(widget.facility.name,
                      style: const TextStyle(
                          color: Color.fromRGBO(94, 97, 115, 1), fontSize: 35),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
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
                  SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            child: const Icon(
                              Icons.house_sharp,
                              color: Color.fromRGBO(94, 97, 115, 1),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.facility.address,
                              style: const TextStyle(
                                color: Color.fromRGBO(94, 97, 115, 1),
                                fontSize: 17,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            child: const Icon(
                              Icons.phone,
                              color: Color.fromRGBO(94, 97, 115, 1),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.facility.phoneNumber,
                              style: const TextStyle(
                                color: Color.fromRGBO(94, 97, 115, 1),
                                fontSize: 17,
                              ),
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                            ),
                          )
                        ],
                      ),
                      DropdownSearch<String>.multiSelection(
                        popupProps: const PopupPropsMultiSelection.dialog(
                          showSearchBox: true,
                          searchDelay: Duration(seconds: 0),
                          searchFieldProps: TextFieldProps(
                            autofocus: true,
                          ),
                        ),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                          labelText: "Add or remove tags for this facility",
                          contentPadding: EdgeInsets.all(5),
                          border: InputBorder.none,
                        )),
                        dropdownButtonProps: const DropdownButtonProps(
                            icon: Icon(
                          Icons.add_box,
                          size: 30,
                        )),
                        items: DataService.availableTags,
                        selectedItems:
                            widget.facility.tags.map((tag) => tag.name).toList(),
                        onChanged: (List<String>? selectedTags) {
                          final ref = FirebaseFirestore.instance
                              .collection('facility')
                              .doc(widget.facility.id);

                          ref.update({
                            'tags': selectedTags
                                ?.map((tag) => FirebaseFirestore.instance
                                    .collection('tag')
                                    .doc(tag))
                                .toList()
                          });
                        },
                      ),
                      /*Wrap(
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
                            ),*/
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
                  )),
                  myRating,
                  const SizedBox(
                    height: 30,
                    child: Text(
                      "Write review:",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                          height: 100,
                          child: TextField(
                            controller: reviewController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter your review here',
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: (){
                              submitReview();
                            },
                            child: Text("Submit")),
                  SizedBox(
                    height: 100,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            "Reviews:",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          FutureBuilder(
                            future: getReviews(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Expanded(
                                      child: ListView.builder(
                                          itemCount: reviews!.length,
                                          itemBuilder: (context, index) => Review(
                                              review: reviews![index].data()!['review'],
                                              user: reviews![index].data()!['userID'],
                                            )
                                          )
                                      );
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                          )
                        ],
                      )
                    ),
                  ),
                  SizedBox(height: 300,)
                ],

              ),
              const Positioned(
                  bottom: 0, left: 0, child: NavigationWidget(selectedIndex: 4)),
            ]);
            }
          }
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


class Review extends StatelessWidget {

  final String review;
  final String date;
  final String rating;
  final String user;

  const Review({
    Key? key,
    required this.review,
    required this.date,
    required this.rating,
    required this.user}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Text(review),
        Text(date),
        Row(
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
          ],
        ),
        Text(user)
      ],)
    );
  }
}
