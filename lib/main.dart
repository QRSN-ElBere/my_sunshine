import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_sunshine/generated/l10n.dart';
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
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
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
          locale: const Locale('en'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          debugShowCheckedModeBanner: false,
        )
    );
  });
}
