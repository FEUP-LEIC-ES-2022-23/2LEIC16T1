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
    ),
    GridItemData(
      icon: Icons.sports_basketball,
      text: 'Basketball',
      color: Colors.deepOrange,
    ),
    GridItemData(
      icon: Icons.sports_baseball,
      text: 'Baseball',
      color: Colors.blue,
    ),
    GridItemData(
      icon: Icons.sports_tennis,
      text: 'Tennis',
      color: Colors.green,
    ),
    GridItemData(
      icon: Icons.sports_volleyball,
      text: 'Volleyball',
      color: Colors.amber,
    ),
    GridItemData(
      icon: Icons.fitness_center,
      text: 'Weigthlifting',
      color: Colors.lightGreen,
    ),
    GridItemData(
      icon: Icons.sports_cricket,
      text: 'Cricket',
      color: Colors.orange,
    ),
    GridItemData(
      icon: Icons.sports_rugby,
      text: 'Rugby',
      color: Colors.deepPurple,
    ),
    GridItemData(
      icon: Icons.sports_hockey,
      text: 'Hockey',
      color: Colors.red,
    ),
    GridItemData(
      icon: Icons.water,
      text: 'Swimming',
      color: Colors.teal,
    ),
    GridItemData(
      icon: Icons.sports_handball,
      text: 'Handball',
      color: Colors.purple,
    ),
    GridItemData(
      icon: Icons.downhill_skiing,
      text: 'Skiing',
      color: Colors.cyan,
    ),
    GridItemData(
      icon: Icons.sports_tennis,
      text: 'Badminton',
      color: Colors.pink,
    ),
    GridItemData(
      icon: Icons.directions_bike,
      text: 'Cycling',
      color: Colors.deepOrangeAccent,
    ),
    GridItemData(
      icon: Icons.sports_martial_arts,
      text: 'Martial Arts',
      color: Colors.lightBlue,
    ),
    GridItemData(
      icon: Icons.sports_golf,
      text: 'Golf',
      color: Colors.amberAccent,
    ),
    GridItemData(
      icon: Icons.directions_run,
      text: 'Running',
      color: Colors.deepPurpleAccent,
    ),
    GridItemData(
      icon: Icons.self_improvement,
      text: 'Yoga',
      color: Colors.greenAccent,
    ),
  ];

  void handleCardTap(String sportName) {
    Navigator.push(
      context,
      PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const SearchScreen(),
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
                  onTap: () => handleCardTap(gridItems[index].text),
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

  GridItemData({required this.icon, required this.text, required this.color});
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
