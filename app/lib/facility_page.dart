import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportspotter/models/data_service.dart';
import 'package:sportspotter/navigation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sportspotter/tools/favourite.dart';
import 'package:sportspotter/tools/rating.dart';
import 'package:sportspotter/tools/review.dart';

import 'models/facility.dart';
import 'models/review.dart';

class FacilityPage extends StatefulWidget {
  final Facility facility;

  const FacilityPage({required this.facility}) :
        super(key: const Key("facility-page"));

  @override
  _FacilityPageState createState() => _FacilityPageState();
}

class _FacilityPageState extends State<FacilityPage> {
  final TextEditingController reviewController = TextEditingController();
  Widget rating = const CircularProgressIndicator();
  Widget myRating = const CircularProgressIndicator();
  double? value = 0;
  double? myValue = 0;
  late List<Review> reviews;
  final User? _user = FirebaseAuth.instance.currentUser;
  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();
    if (_user != null) {
      isFavourite(widget.facility.id, _user!.uid).then(
              (favourite) => setState(() {_isFavourite = favourite;}));
    }
  }

  submitReview() {
    final user = FirebaseAuth.instance.currentUser;
    final description = reviewController.text;
    if (description.isNotEmpty) {
      addReview(widget.facility.id, user!.uid, description).then((value) {
        reviewController.clear();
        setState(() {});
      });
    }
  }

  Future<void> getReviews() async {
    List<Review> result = [];
    List<dynamic>? aux = await getFacilityReviews(widget.facility.id);

    for (int i = 0; i < aux.length; i++) {
      final user = await FirebaseFirestore.instance
          .collection('user')
          .doc(aux[i]['userID'])
          .get();
      String userName = user['firstName'] +
          ' ' +
          user['lastName'] +
          ' (' +
          user['username'] +
          ')';
      String date = aux[i]['date'];
      double? rating =
          await getUserRating(aux[i]['userID'], widget.facility.id);
      String review = aux[i]['review'].toString();
      rating ??= 0;
      result.add(Review(
        review: review,
        date: date,
        user: userName,
        rating: rating.toString(),
      ));
    }

    reviews = result;
  }

  buildRating() async {
    value = await getFacilityRating(widget.facility.id);
    bool loggedIn = _user != null;
    if (loggedIn) {
      myValue = await getUserRating(_user!.uid, widget.facility.id);
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
          onRatingUpdate: (rating) {
            addRating(widget.facility.id, _user!.uid, rating).then((value) => setState(() {}));
          });
    } else {
      myRating = const Text(
        "Log in to rate this facility",
        style: TextStyle(fontSize: 20, color: Colors.grey),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: Key("Facility ${widget.facility.name}"),
        appBar: AppBar(
          iconTheme: const IconThemeData(size: 40, color: Colors.black),
          backgroundColor: const Color(0x00fdfdfd),
          elevation: 0,
          actions: [
            if (_user != null)
              _isFavourite
                  ? IconButton(
                      padding: const EdgeInsets.only(right: 10),
                      icon: const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        removeFavourite(widget.facility.id, _user!.uid);
                        setState(() {
                          _isFavourite = false;
                        });
                      },
                    )
                  : IconButton(
                      padding: const EdgeInsets.only(right: 10),
                      icon: const Icon(
                        Icons.star_outline,
                      ),
                      onPressed: () {
                        addFavourite(widget.facility.id, _user!.uid);
                        setState(() {
                          _isFavourite = true;
                        });
                      },
                    )
          ],
        ),
        body: FutureBuilder(
            future: buildRating(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
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
                          Text(value!.toStringAsFixed(2),
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
                              color: Color.fromRGBO(94, 97, 115, 1),
                              fontSize: 35),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
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
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
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
                            selectedItems: widget.facility.tags
                                .map((tag) => tag.name)
                                .toList(),
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
                          const SizedBox(height: 100)
                        ],
                      )),
                      myRating,
                      const SizedBox(
                        height: 30,
                        child: Text(
                          "Write review:",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        child: TextField(
                          key: const Key("review-field"),
                          controller: reviewController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your review here',
                          ),
                        ),
                      ),
                      TextButton(
                        key: const Key("submit-review-button"),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            submitReview();
                          },
                          child: const Text("Submit")),
                      const SizedBox(
                        height: 30,
                        child: Text(
                          "Reviews:",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 300,
                        child: Center(
                            child: Column(
                          children: [
                            FutureBuilder(
                              future: getReviews(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Expanded(
                                      child: ListView.builder(
                                          itemCount: reviews.length,
                                          itemBuilder: (context, index) =>
                                              Review(
                                                key: Key(reviews[index].review),
                                                review: reviews[index].review,
                                                date: reviews[index].date,
                                                rating: reviews[index].rating,
                                                user: reviews[index].user,
                                              )));
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            )
                          ],
                        )),
                      ),
                      const SizedBox(
                        height: 80,
                      )
                    ],
                  ),
                  const Positioned(
                      bottom: 0,
                      left: 0,
                      child: NavigationWidget(selectedIndex: 4)),
                ]);
              }
            }));
  }
}
