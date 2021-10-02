import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_sunshine/pages/graph_page.dart';
import 'package:my_sunshine/pages/home.dart';
import 'package:my_sunshine/pages/intro.dart';
import 'package:my_sunshine/pages/maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    )
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SharedPreferences.getInstance().then((instance) {
    runApp(
        MaterialApp(
          theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
          initialRoute: instance.getBool('welcome') == false ? '/home' : '/',
          routes: {
            '/': (context) => Introduction(instance),
            '/home': (context) => Home(instance),
            '/graph': (context) => const GraphPage(),
            '/maps': (context) => Maps(instance),
          },
          debugShowCheckedModeBanner: false,
        )
    );
  });
}
