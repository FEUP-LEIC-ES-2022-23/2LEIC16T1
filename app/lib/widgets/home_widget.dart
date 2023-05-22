import 'package:flutter/material.dart';
import 'package:sportspotter/search_page.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List<GridItemData> gridItems = [
    GridItemData(
      icon: Icons.sports_soccer,
      text: 'Soccer',
      color: Colors.indigo,
      tag: 'soccer',
    ),
    GridItemData(
      icon: Icons.sports_basketball,
      text: 'Basketball',
      color: Colors.deepOrange,
      tag: 'soccer',
    ),
    GridItemData(
      icon: Icons.sports_baseball,
      text: 'Baseball',
      color: Colors.blue,
      tag: 'soccer',
    ),
    GridItemData(
      icon: Icons.sports_tennis,
      text: 'Tennis',
      color: Colors.green,
      tag: 'soccer',
    ),
    GridItemData(
      icon: Icons.sports_volleyball,
      text: 'Volleyball',
      color: Colors.amber,
      tag: 'soccer',
    ),
    GridItemData(
      icon: Icons.fitness_center,
      text: 'Weigthlifting',
      color: Colors.lightGreen,
      tag: 'soccer',
    ),
    GridItemData(
      icon: Icons.sports_cricket,
      text: 'Cricket',
      color: Colors.orange,
      tag: 'soccer',
    ),
    GridItemData(
      icon: Icons.sports_rugby,
      text: 'Rugby',
      color: Colors.deepPurple,
      tag: 'soccer',
    ),
    GridItemData(
      icon: Icons.sports_hockey,
      text: 'Hockey',
      color: Colors.red,
      tag: 'soccer',
    ),
    GridItemData(
      icon: Icons.water,
      text: 'Swimming',
      color: Colors.teal,
      tag: 'soccer',
    ),
    GridItemData(
      icon: Icons.sports_handball,
      text: 'Handball',
      color: Colors.purple,
      tag: 'soccer',
    ),
    GridItemData(
      icon: Icons.downhill_skiing,
      text: 'Skiing',
      color: Colors.cyan,
      tag: 'soccer',
    ),
    GridItemData(
      icon: Icons.sports_tennis,
      text: 'Badminton',
      color: Colors.pink,
      tag: 'soccer',
    ),
    GridItemData(
      icon: Icons.directions_bike,
      text: 'Cycling',
      color: Colors.deepOrangeAccent,
      tag: 'soccer',
    ),
    GridItemData(
      icon: Icons.sports_martial_arts,
      text: 'Martial Arts',
      color: Colors.lightBlue,
      tag: 'soccer',
    ),
    GridItemData(
      icon: Icons.sports_golf,
      text: 'Golf',
      color: Colors.amberAccent,
      tag: 'soccer',
    ),
    GridItemData(
      icon: Icons.directions_run,
      text: 'Running',
      color: Colors.deepPurpleAccent,
      tag: 'soccer',
    ),
    GridItemData(
      icon: Icons.self_improvement,
      text: 'Yoga',
      color: Colors.greenAccent,
      tag: 'soccer',
    ),
  ];

  void handleCardTap(String sportTag) {
    Navigator.push(
      context,
      PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => SearchScreen(
                sportTag: sportTag,
              ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: const Text(
                'SportSpotter',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: gridItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                return GridItem(
                  icon: gridItems[index].icon,
                  text: gridItems[index].text,
                  color: gridItems[index].color,
                  onTap: () => handleCardTap(gridItems[index].tag),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GridItemData {
  final IconData icon;
  final String text;
  final Color color;
  final String tag;

  GridItemData(
      {required this.icon,
      required this.text,
      required this.color,
      required this.tag});
}

class GridItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const GridItem({
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                  child: Icon(
                    icon,
                    size: 96,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
