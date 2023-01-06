import 'dart:convert';
import 'package:a221_lab_ass_2/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'shared/config.dart';
import 'views/screens/mainscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var http;
  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text(
                "Homestay Raya",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              CircularProgressIndicator(),
              Text("Version 0.1b")
            ]),
      ),
    );
  }

  Future<void> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _email = (prefs.getString('email')) ?? '';
    String _pass = (prefs.getString('pass')) ?? '';
    if (_email.isNotEmpty) {
      http.post(Uri.parse("${Config.server}/php/login_user.php"),
          body: {"email": _email, "password": _pass}).then((response) {
        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          User user = User.fromJson(jsonResponse['data']);
          Timer(
              const Duration(seconds: 5),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainScreen(user: user))));
        } else {
          User user = User(
              id: "0",
              email: "unregistered",
              name: "unregistered",
              address: "na",
              phone: "012345678",
              regdate: "0");
          Timer(
              const Duration(seconds: 5),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainScreen(user: user))));
        }
      });
    } else {
      User user = User(
          id: "0",
          email: "unregistered",
          name: "unregistered",
          address: "na",
          phone: "012345678",
          regdate: "0");
      Timer(
          const Duration(seconds: 5),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainScreen(user: user))));
    }
  }
}
