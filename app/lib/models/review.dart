import 'package:flutter/material.dart';

class Review extends StatelessWidget {
  final String review;
  final String date;
  final String rating;
  final String user;

  const Review(
      {Key? key,
        required this.review,
        required this.date,
        required this.rating,
        required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 35),
      padding: const EdgeInsets.all(10),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              Text(
                user,
                style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                date,
                style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              for (int i = 0; i < 5; i++)
                Container(
                  margin: EdgeInsets.fromLTRB(
                    i == 0 ? 10 : 4,
                    4,
                    i == 4 ? 15 : 4,
                    4,
                  ),
                  child: Icon(
                    i < double.parse(rating).floor()
                        ? Icons.star
                        : i < double.parse(rating).ceil()
                        ? Icons.star_half
                        : Icons.star_outline,
                    size: 20,
                    color: Colors.amber,
                  ),
                ),
            ],
          ),
          Text(
            review,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}