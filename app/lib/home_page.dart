import 'package:flutter/material.dart';
import 'package:sportspotter/widgets/home_widget.dart';
import 'navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: const Key("home page"),
        automaticallyImplyLeading: false,
        title: const Text('Home page'),
      ),
      body: Column(
        children: const [
          Expanded(
            child: HomeWidget(),
          ),
          NavigationWidget(selectedIndex: 0),
        ],
      ),
    );
  }
}
