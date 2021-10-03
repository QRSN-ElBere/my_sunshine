import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Introduction extends StatefulWidget {
  final SharedPreferences sharedPrefs;

  const Introduction(this.sharedPrefs, {Key? key}) : super(key: key);

  @override
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async {
    bool welcome = widget.sharedPrefs.getBool('welcome') ?? true;
    if (welcome) {
      widget.sharedPrefs.setBool('welcome', welcome);
      Navigator.pushReplacementNamed(context, '/maps');
    } else {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Widget _buildImage(String assetName, [double width = 300]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0, letterSpacing: 1, wordSpacing: 2, fontWeight: FontWeight.w300);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalHeader: Align(
        alignment: Alignment.topLeft,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 0, left: 5),
            child: Image.asset('assets/QRSN.png', width: 65),
          ),
        ),
      ),
      globalBackgroundColor: const Color(0xff2e2e2e),
      globalFooter: Padding(
        padding: const EdgeInsets.all(10),
        child: RawMaterialButton(
          onPressed: () => _onIntroEnd(context),
          fillColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 10,
          child: const SizedBox(
            width: double.infinity,
            height: 60,
            child: Center(
              child: Text(
                'Let\'s go right away!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Times New Roman'
                ),
              ),
            )
          ),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Hello There!",
          body:
          "Welcome to My Sunshine.\n\nWhere you can view data about the weather and the \"Sunshine\"",
          image: _buildImage('logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Interactive Design",
          body: "Graphs allow Zooming and Panning.\n\nAlongside toggling the visibility of different parameters.",
          image: _buildImage('zoom_pan.gif', 400),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Choose The Location",
          body: "You can either locate your location automatically, choose the location manually, or search for it.",
          image: ClipRRect(
            child: _buildImage('map_page.png', 400),
            borderRadius: BorderRadius.circular(5),
          ),
          decoration: pageDecoration.copyWith(
            imageFlex: 1,
            imagePadding: const EdgeInsets.only(top: 50),
          ),
        ),
        PageViewModel(
          title: "Data Inconsistency",
          body: "If your graph looks like this.\n\nThis means that the data at the corresponding dates are unavailable.",
          image: _buildImage('gaps.jpg'),
          decoration: pageDecoration
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text('Skip', style: TextStyle(color: Colors.black)),
      next: const Icon(Icons.arrow_forward, color: Colors.black,),
      done: const Text(
        'Done',
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Color(0xff7c8083),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
