import 'dart:async';
import 'dart:convert';
import 'package:a221_lab_ass_2/models/user.dart';
import 'package:a221_lab_ass_2/registrationscreen.dart';
import 'package:a221_lab_ass_2/shared/config.dart';
import 'package:a221_lab_ass_2/views/screens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  var screenHeight, screenWidth, cardwidth;
  get _loginUser => null;
  get http => null;

  @override
  void initState() {
    super.initState();
    User user = User(
      id: "0",
      email: "unregistered",
      name:"unregistered",
      address: "na",
      phone: "0123456789",
      regdate: "0");
      Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(context, 
        MaterialPageRoute(builder: (content) => MainScreen(user:user)))
      );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      cardwidth = screenWidth;
    } else {
      cardwidth = 400.00;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: SizedBox(
          width: cardwidth,
          child: Card(
            elevation: 8,
            margin: const EdgeInsets.all(8),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                        controller: _emailEditingController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => val!.isEmpty ||
                                !val.contains("@") ||
                                !val.contains(".")
                            ? "Enter a valid email address"
                            : null,
                        decoration: const InputDecoration(
                            labelText: 'Email address',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.email),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.0),
                            ))),
                    TextFormField(
                        controller: _passEditingController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.password),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.0),
                          ),
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value!;
                              saveremoveprof(value);
                            });
                          },
                        ),
                        Flexible(
                          child: GestureDetector(
                            onTap: null,
                            child: const Text('Remember Me',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          minWidth: 115,
                          height: 50,
                          elevation: 10,
                          onPressed: _loginUser,
                          color: Theme.of(context).colorScheme.primary,
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: _goLogin,
                      child: const Text(
                        "Don't have an account. Register now",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: _goHome,
                      child: const Text("Go back Home",
                          style: TextStyle(fontSize: 18)),
                    )
                  ],
                )),
          ),
        ),
      )),
    );
  }

  // ignore: non_constant_identifier_names
  void_loginUser() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please fill in the login credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          fontSize: 14.0);
      return;
    }

    String _email = _emailEditingController.text;
    String _pass = _passEditingController.text;
    http.post(Uri.parse("${Config.server}/php/login_user.php"),
        body: {"email": _email, "password": _pass}).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print(jsonResponse);
        User user = User.fromJson(jsonResponse['data']);
        //User user = User(id: jsonResponse['id'],name: jsonResponse['name'], email: jsonResponse['email'], phone: jsonResponse['phone'], address: jsonResponse['address'], regdate: jsonResponse['regdate']);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => MainScreen(
                      user: user,
                    )));
      } else {
        Fluttertoast.showToast(
          msg: "Login Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      }
    });
  }

  void _goHome() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const RegistrationScreen()));
  }

  void _goLogin() {
    Navigator.push(context,
        MaterialPageRoute(builder: ((context) => const RegistrationScreen())));
  }

  void saveremoveprof(bool value) async {
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    var SharedPreferences;
    var prefs = await SharedPreferences.getInstance();
    if (value) {
      if (!_formKey.currentState!.validate()) {
        Fluttertoast.showToast(
            msg: "Please fill in the login credentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        _isChecked = false;
        return;
      }
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      Fluttertoast.showToast(
          msg: "Preference Stored",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    } else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        _isChecked = false;
      });
      Fluttertoast.showToast(
          msg: "Preference Removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.length > 1) {
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
        _isChecked = true;
      });
    }
  }
}
