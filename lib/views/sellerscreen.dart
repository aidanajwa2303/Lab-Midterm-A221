import 'dart:convert';
import 'dart:math';
import 'package:a221_lab_ass_2/loginscreen.dart';
import 'package:a221_lab_ass_2/registrationscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../shared/config.dart';
import '../shared/mainmenu.dart';
import 'screens/newproductscreen.dart';

class SellerScreen extends StatefulWidget {
  final User user;
  const SellerScreen({super.key, required this.user});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  var _lat, _lng;
  late Positioned _position;
  List<Product> productList = <Product>[];
  String titlecenter = "Loading...";
  get http => null;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(title: const Text("Seller"), actions: [
            IconButton(
                onPressed: _registrationForm,
                icon: const Icon(Icons.app_registration)),
            IconButton(onPressed: _loginForm, icon: const Icon(Icons.login)),
            PopupMenuButton(itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("New Product"),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("My Order"),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                _gotNewProduct();
                print("My account menu is selected.");
              } else if (value == 1) {
                print("Setting menu is selected.");
              } else if (value == 2) {
                print("Logout menu is selected.");
              }
            }),
          ]),
          body: productList.isEmpty
              ? Center(
                  child: Text(titlecenter,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)))
              : Column(
                  children: [
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: List.generate(productList.length, (index) {
                          return Card(
                            child: Column(children: [
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  width: 120,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${Config.server}/a221_lab_ass_2/images/products/${productList[index].productsId}.jpg",
                                  Placeholder: (context, url) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Flexible(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      Text(productList[index]
                                          .productsName
                                          .toString()),
                                      Text(
                                          "RM ${productList[index].productsPrice}"),
                                    ],
                                  ))
                            ]),
                          );
                        }),
                      ),
                    )
                  ],
                ),
          drawer: MainMenuWidget(user: widget.user)),
    );
  }

  void _registrationForm() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const RegistrationScreen()));
  }

  void _loginForm() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Future<void> _gotNewProduct() async {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please register your account",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (await _checkPermisionGetLoc()) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => NewProductScreen(
                    position: _position,
                    user: widget.user,
                  )));
      _loadProducts();
    } else {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 12.0);
    }
  }

  Future<bool> _checkPermisionGetLoc() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Please allow the app to access the location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 12.0);
        Geolocator.openLocationSettings();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 12.0);
      Geolocator.openLocationSettings();
      return false;
    }
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return true;
  }

  void _loadProducts() {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please register your account first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 12.0);
      return;
    }
    http
        .get(
      Uri.parse(
          "${Config.server}/php/loadsellerproducts.php?userid=${widget.user.id}"),
    )
        .then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          if (extractdata['products'] != null) {
            productList = <Product>[];
            extractdata['products'].forEach((v) {
              productList.add(Product.fromJson(v));
            });
            titlecenter = "Founded";
          } else {
            titlecenter = "No homestay available";
            productList.clear();
          }
        }
      } else {
        titlecenter = "No Homestay Available";
        productList.clear();
      }
      setState(() {});
    });
  }
}
