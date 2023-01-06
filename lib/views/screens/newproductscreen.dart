import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/user.dart';
import '../../shared/config.dart';

class NewProductScreen extends StatefulWidget {
  final User user;
  const NewProductScreen(
      {super.key, required this.user, required Positioned position});

  @override
  State<NewProductScreen> createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  final TextEditingController _prnameEditingController =
      TextEditingController();
  final TextEditingController _prdescEditingController =
      TextEditingController();
  final TextEditingController _prpriceEditingController =
      TextEditingController();
  final TextEditingController _prdelEditingController = TextEditingController();
  final TextEditingController _prqtyEditingController = TextEditingController();
  final TextEditingController _prstateEditingController =
      TextEditingController();
  final TextEditingController _prlocalEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _lat, _lng;
  get http => null;

  @override
  void initState() {
    super.initState();
    _lat = widget.position.latitude.toString();
    _lng = widget.position.longitude.toString();
  }

  File? _image;
  var pathAsset = "assets/images/camera.jpg";
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("New Product/Service")),
        body: SingleChildScrollView(
          child: Column(children: [
            Card(
              elevation: 10,
              child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _image == null
                          ? AssetImage(pathAsset)
                          : FileImage(_image!) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  )),
            ),
            const Text(
              "Add New Product",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(children: [
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty || (val.length < 3)
                          ? "Product name must be longer than 3 character"
                          : null,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: 'Product Name',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.person),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ))),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty || (val.length < 10)
                          ? "Product description must be longer than 20 character"
                          : null,
                      maxLines: 5,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: 'Product Description',
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(),
                          icon: Icon(
                            Icons.person,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ))),
                  Row(
                    children: [
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Product price must contain value"
                                : null,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Product Price',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.money),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Quantity should be more than one"
                                : null,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Product Quantity',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.ad_units),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Current State"
                                      : null,
                              enabled: false,
                              controller: _prstateEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Current State',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.flag),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  )))),
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            enabled: false,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Current Locality"
                                : null,
                            controller: _prlocalEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Current Locality',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.map),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      child: const Text('Add Product'),
                      onPressed: () => {
                        _newProductDialog(),
                      },
                    ),
                  )
                ]),
              ),
            )
          ]),
        ));
  }

  _newProductDialog() {
    if (_image == null) {
      Fluttertoast.showToast(
          msg: "Please take picture of your product/service",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 12.0);
      return;
    }
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please check agree checkbox",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 12.0);
      return;
    }
    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please check agree checkbox",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 12.0);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18.0))),
          title: const Text(
            "Insert this product/service?",
            style: TextStyle(),
          ),
          content: const Text(
              "Are you sure want to insert this product/service?",
              style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                insertProduct();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _selectImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text(
              "Select picture from",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    iconSize: 50,
                    onPressed: _onCamera,
                    icon: const Icon(Icons.camera)),
                IconButton(
                    iconSize: 50,
                    onPressed: _onGallery,
                    icon: const Icon(Icons.browse_gallery)),
              ],
            ));
      },
    );
  }

  void insertProduct() {
    String prname = _prnameEditingController.text;
    String prdesc = _prdescEditingController.text;
    String prprice = _prpriceEditingController.text;
    String prqty = _prqtyEditingController.text;
    String prstate = _prstateEditingController.text;
    String prlocal = _prdelEditingController.text;
    String based64Image = base64Encode(_image!.readAsBytesSync());

    http.post(Uri.parse("${Config.server}/php/insert_product.php"), body: {
      "userid": widget.user.id,
      "prname": prname,
      "prdesc": prdesc,
      "prprice": prprice,
      "qty": prqty,
      "state": prstate,
      "local": prlocal,
      "lat": _lat,
      "lon": _lng,
      "image": based64Image
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == "success") {
        Fluttertoast.showToast(
            msg: "Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 12.0);
        Navigator.of(context).pop();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 12.0);
        return;
      }
    });
  }
}

Future<void> _onCamera() async {
  Navigator.pop(context);
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(
    source: ImageSource.camera,
    maxHeight: 500,
    maxWidth: 500,
  );
  if (pickedFile != null) {
    _image = File(pickedFile.path);
    setState(() {});
  } else {
    print('No image found');
  }
}

Future<void> _onGallery() async {
  Navigator.pop(context);
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(
    source: ImageSource.gallery,
    maxHeight: 500,
    maxWidth: 500,
  );
  if (pickedFile != null) {
    _image = File(pickedFile.path);
    cropImage();
  } else {
    print('No image found');
  }

  Future<void> cropImage() async {
    CroppedFile? CroppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPresent.square,
      ],
      uiSetting: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.lightGreen,
            initAspectRatio: CropAspectRatioPresent.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (CroppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      setState(() {});
    }
  }

  Future<Position> _checkLocPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled) {
      return Future.error('Location service is not enabled');
    }
    permission = await Geolocator.checkLocPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied) {
        return Future.error('Location permissions is not enable');
      }
    }
    if(permission == LocationPermission.deniedForever){
      return Future.error('Location permissions are permanently disabled.');
    }
    return await Geolocator.getCurrentPosition();
  }
}
