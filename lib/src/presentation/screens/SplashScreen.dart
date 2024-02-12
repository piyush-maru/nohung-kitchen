import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/res.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;
  AnimationController? animationController;
  Animation<double>? animation;

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? isLogged = sharedPreferences.getBool("isLoggedIn");

    print(isLogged);

    if (isLogged == true) {
      Navigator.pushReplacementNamed(context, '/homebase');
    } else {
      Navigator.pushReplacementNamed(context, '/loginSignUp');
    }
  }

  @override
  dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation = new CurvedAnimation(
        parent: animationController!, curve: Curves.bounceInOut);
    animation!.addListener(() => this.setState(() {}));
    animationController!.forward();
    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  Future<void> setupToken() async {
    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);

    // Save the initial token to the database
    //await saveTokenToDatabase(token!);

    // Any time the token refreshes, store this in the database too.
    //FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            InkWell(
                onTap: () {
                  startTime();
                },
                child: Image.asset(
                  Res.ic_bg,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                )),
            Center(
              child: Image.asset(Res.ic_logo,
                  width: animation!.value * 100,
                  height: animation!.value * 100),
            ),
          ],
        ),

        /*child: Image.asset(
            Res.ic_logo,
            width: animation.value * 160,
            height: animation.value * 160,
          ),*/
      ),
    );
  }
}
