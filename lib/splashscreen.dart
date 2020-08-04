import 'package:flutter/material.dart';
import 'package:counsel_book/loginscreen.dart';
import 'package:progress_indicators/progress_indicators.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double screenHeight;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: 'CounselBook',
      home: Scaffold(
          body: Container(
        child: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/splash.jpeg'),
                        fit: BoxFit.cover))),
            Container(height: 600, child: ProgressIndicator())
          ],
        ),
      )),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          //updating states
          if (animation.value > 0.99) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen()));
          }
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container( 
      child: new Column(mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('assets/images/counsel.png'),
        SizedBox(height: 5),
        ScalingText('Loading...'),
      ],)
    ));
  }
}
