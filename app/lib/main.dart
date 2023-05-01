import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sportspotter/models/data_service.dart';
import 'package:sportspotter/navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sportspotter/utils.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DataService.getTags();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('pt', 'PT'),
        Locale('en', 'US'),
      ],
      locale: const Locale('pt'),
      title: 'SportSpotter',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Home Page'),
        ),
        body: Stack(
          children: const [
            Positioned(
                bottom: 0, left: 0, child: NavigationWidget(selectedIndex: 0))
          ],
        ));
  }
}
