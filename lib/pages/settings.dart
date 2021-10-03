import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_sunshine/pages/list_parameters.dart';
import 'package:my_sunshine/services/parameters.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final Parameters parameters;
  final SharedPreferences sharedPrefs;

  const Settings(this.sharedPrefs, this.parameters, {Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final PageController controller = PageController(initialPage: 0,);
  List<ListTile> _settingsOptions = [];
  final double _fontSize = 20;
  final double _iconSize = 40;
  Color iconsColor = const Color(0xff7c8083);
  late final double width;
  late final double height;

  @override
  void didChangeDependencies() {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _settingsOptions = [
      ListTile(
        onTap: () {controller.animateToPage(
            2,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeIn
        );},
        title: Text(
          'Change Language',
          style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.w500),
        ),
        leading: Icon(Icons.translate, size: _iconSize, color: iconsColor),
      ),
      ListTile(
        onTap: () {Navigator.pushNamed(context, '/maps');},
        title: Text(
          'Change Location',
          style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.w500),
        ),
        leading: Icon(Icons.location_on, size: _iconSize, color: iconsColor),
      ),
      ListTile(
        onTap: () {controller.animateToPage(
          1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn
        );},
        title: Text(
          'Choose your parameters',
          style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.w500),
        ),
        leading: Icon(Icons.addchart, size: _iconSize, color: iconsColor),
      ),
      ListTile(
        onTap: () {Navigator.pushReplacementNamed(context, '/');},
        title: Text(
          'Help',
          style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.w500),
        ),
        leading: Icon(Icons.help_outline, size: _iconSize, color: iconsColor),
      ),
    ];
  }

  Widget settingsList() {
    return ListView.builder(
      itemCount: _settingsOptions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Card(
              color: const Color(0xff2e2e2e),
              elevation: 5,
              child: _settingsOptions[index]
          ),
        );
      },
    );
  }

  Widget subPage({required Widget child}) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: const Color(0xff132030),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {controller.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeIn
                );},
                icon: const Icon(Icons.arrow_back),
                iconSize: 30,
              ),
              child
            ],
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.animateToPage(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn
        );
        widget.parameters.refresh();
        return false;
      },
      child: Container(
        color: const Color(0xff132030),
        child: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: [
            settingsList(),
            subPage(child: ListParameters(widget.sharedPrefs, widget.parameters)),
            // TODO
            subPage(
              child: const Center(
                child: Text(
                  'Future Update',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.red
                  ),
                )
              )
            )
          ]
        ),
      ),
    );
  }
}
