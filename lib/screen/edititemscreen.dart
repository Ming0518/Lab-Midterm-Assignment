import 'dart:convert';
//import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:barterlt/item.dart';
import 'package:barterlt/user.dart';
//import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:barterlt/myconfig.dart';

class EditItemScreen extends StatefulWidget {
  final User user;
  final Item useritem;

  const EditItemScreen({super.key, required this.user, required this.useritem});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  //File? _image;
  var pathAsset = "assets/images/camera.png";
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _catchnameEditingController =
      TextEditingController();
  final TextEditingController _catchdescEditingController =
      TextEditingController();
  final TextEditingController _catchpriceEditingController =
      TextEditingController();
  // final TextEditingController _catchqtyEditingController =
  //TextEditingController();
  final TextEditingController _prstateEditingController =
      TextEditingController();
  final TextEditingController _prlocalEditingController =
      TextEditingController();
  String selectedType = "Fish";
  List<String> catchlist = [
    "Fish",
    "Crab",
    "Squid",
    "Oysters",
    "Mussels",
    "Octopus",
    "Scallops",
    "Lobsters",
    "Other",
  ];

  String curaddress = "";
  String curstate = "";
  String prlat = "";
  String prlong = "";

  @override
  void initState() {
    super.initState();
    _catchnameEditingController.text = widget.useritem.itemName.toString();
    _catchdescEditingController.text = widget.useritem.itemDesc.toString();
    _catchpriceEditingController.text =
        double.parse(widget.useritem.itemValue.toString()).toStringAsFixed(2);
    //_catchqtyEditingController.text = widget.useritem.catchQty.toString();
    _prstateEditingController.text = widget.useritem.itemState.toString();
    _prlocalEditingController.text = widget.useritem.itemLocality.toString();
    //selectedType = widget.useritem.catchType.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Item",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Column(children: [
        Flexible(
            flex: 4,
            // height: screenHeight / 2.5,
            // width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Card(
                child: Container(
                  width: screenWidth,
                  child: CachedNetworkImage(
                    width: screenWidth,
                    fit: BoxFit.cover,
                    imageUrl:
                        "${MyConfig().SERVER}/barterlt/assets/items/${widget.useritem.itemId}_1.png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            )),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.type_specimen),
                        const SizedBox(
                          width: 16,
                        ),
                        // SizedBox(
                        //   height: 60,
                        //   child: DropdownButton(
                        //     //sorting dropdownoption
                        //     // Not necessary for Option 1
                        //     value: selectedType,
                        //     onChanged: (newValue) {
                        //       setState(() {
                        //         selectedType = newValue!;
                        //         print(selectedType);
                        //       });
                        //     },
                        //     items: catchlist.map((selectedType) {
                        //       return DropdownMenuItem(
                        //         value: selectedType,
                        //         child: Text(
                        //           selectedType,
                        //         ),
                        //       );
                        //     }).toList(),
                        //   ),
                        // ),
                        Expanded(
                          child: TextFormField(
                              //enabled: false,
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Item name must be longer than 3"
                                      : null,
                              onFieldSubmitted: (v) {},
                              controller: _catchnameEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Item Name',
                                  labelStyle: TextStyle(),
                                  //icon: Icon(Icons.abc),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        )
                      ],
                    ),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty
                            ? "Item description must be longer than 10"
                            : null,
                        onFieldSubmitted: (v) {},
                        maxLines: 4,
                        controller: _catchdescEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Item Description',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(),
                            icon: Icon(
                              Icons.description,
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
                              validator: (val) => val!.isEmpty
                                  ? "Product price must contain value"
                                  : null,
                              onFieldSubmitted: (v) {},
                              controller: _catchpriceEditingController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Item Value',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.money),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                        // Flexible(
                        //   flex: 5,
                        //   child: TextFormField(
                        //       textInputAction: TextInputAction.next,
                        //       validator: (val) => val!.isEmpty
                        //           ? "Quantity should be more than 0"
                        //           : null,
                        //       controller: _catchqtyEditingController,
                        //       keyboardType: TextInputType.number,
                        //       decoration: const InputDecoration(
                        //           labelText: 'Item Quantity',
                        //           labelStyle: TextStyle(),
                        //           icon: Icon(Icons.numbers),
                        //           focusedBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(width: 2.0),
                        //           ))),
                        // ),
                      ],
                    ),
                    Row(children: [
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length < 3)
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
                                ))),
                      ),
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
                      ),
                    ]),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: screenWidth / 1.2,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            udpateDialog();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors
                                .green, // Set the background color to green
                          ),
                          child: const Text("Update Item")),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  void udpateDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Update your catch?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                updateCatch();
                //registerUser();
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

  void updateCatch() {
    String itemname = _catchnameEditingController.text;
    String itemdesc = _catchdescEditingController.text;
    String itemvalue = _catchpriceEditingController.text;
    //String catchqty = _catchqtyEditingController.text;

    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/update_item.php"),
        body: {
          "itemid": widget.useritem.itemId,
          "itemname": itemname,
          "itemdesc": itemdesc,
          "itemvalue": itemvalue,
          //"catchqty": catchqty,
          //"type": selectedType,
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Success")));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Failed")));
        Navigator.pop(context);
      }
    });
  }
}
