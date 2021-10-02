import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_sunshine/pages/main_page.dart';
import 'package:my_sunshine/pages/settings.dart';
import 'package:my_sunshine/services/parameters.dart';
import 'package:my_sunshine/services/nasa_power.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Home extends StatefulWidget {

  final SharedPreferences sharedPrefs;

  const Home(this.sharedPrefs, {Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  RequestNASAPower request = RequestNASAPower();
  final PageController controller = PageController(initialPage: 0,);
  late Parameters parameters;
  late final List<StatefulWidget> pages;
  int _pageIndex = 0;
  bool welcome = false;
  late double width;
  late double height;

  @override
  void initState() {
    super.initState();
    parameters = Parameters(widget.sharedPrefs);
    pages = [
      Main(widget.sharedPrefs, parameters),
      Settings(widget.sharedPrefs, parameters)
    ];
  }

  @override
  void didChangeDependencies() {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    rebuildAllChildren(context);
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xff132030),
        animationDuration: const Duration(milliseconds: 400),
        color: const Color(0xff7c8083),
        height: 50,
        index: _pageIndex,
        items: const [
          Icon(Icons.home, size: 30),
          Icon(Icons.settings, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _pageIndex = index;
            controller.animateToPage(
              index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn
            );
          });
        },
      ),
      body: PageView(
        controller: controller,
        children: pages,
        onPageChanged: (index) {setState(() {_pageIndex = index;});},
      )
    );
  }
}
