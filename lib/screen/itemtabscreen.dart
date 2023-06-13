import 'package:flutter/material.dart';
import 'package:barterlt/user.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:flutter/material.dart';
import 'package:barterlt/item.dart';
import 'package:http/http.dart' as http;
import 'package:barterlt/myconfig.dart';
import 'edititemscreen.dart';
import 'newitemscreen.dart';

class ItemTabScreen extends StatefulWidget {
  final User user;
  const ItemTabScreen({super.key, required this.user});

  @override
  State<ItemTabScreen> createState() => _ItemTabScreenState();
}

class _ItemTabScreenState extends State<ItemTabScreen> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  late List<Widget> tabchildren;
  List<Item> itemList = <Item>[];

  @override
  void initState() {
    super.initState();
    loaduserItems();
    print("Seller");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }

    return Scaffold(
      body: RefreshIndicator(
          onRefresh: _refresh,
          child: itemList.isEmpty
              ? const Center(
                  child: Text("No Data"),
                )
              : Column(children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 24,
                    color: Colors.lightGreen,
                    alignment: Alignment.center,
                    child: Text(
                      "${itemList.length} Items Found",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: axiscount,
                        children: List.generate(
                          itemList.length,
                          (index) {
                            return Container(
                              height:
                                  400, // Set the desired height for the card
                              child: Card(
                                child: InkWell(
                                  onLongPress: () {
                                    onDeleteDialog(index);
                                  },
                                  onTap: () async {
                                    Item singlecatch =
                                        Item.fromJson(itemList[index].toJson());
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (content) => EditItemScreen(
                                          user: widget.user,
                                          useritem: singlecatch,
                                        ),
                                      ),
                                    );
                                    loaduserItems();
                                  },
                                  child: Column(
                                    children: [
                                      CachedNetworkImage(
                                        width: screenWidth,
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            "${MyConfig().SERVER}/barterlt/assets/items/${itemList[index].itemId}_1.png",
                                        placeholder: (context, url) =>
                                            const LinearProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                      Text(
                                        itemList[index].itemName.toString(),
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        "Condition: ${double.parse(itemList[index].itemValue.toString()).toStringAsFixed(2)}/10.00",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "${itemList[index].itemState},${itemList[index].itemLocality}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ])),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () async {
            if (widget.user.id != "na") {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => NewItemScreen(
                            user: widget.user,
                          )));
              loaduserItems();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please login/register an account")));
            }
          },
          child: const Text(
            "+",
            style: TextStyle(fontSize: 32),
          )),
    );
  }

  void loaduserItems() {
    if (widget.user.id == "na") {
      setState(() {
        // titlecenter = "Unregistered User";
      });
      return;
    }

    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/load_item.php"),
        body: {"userid": widget.user.id}).then((response) {
      //print(response.body);
      log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          print(itemList[0].itemName);
        }
        setState(() {});
      }
    });
  }

  void onDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete ${itemList[index].itemName}?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteCatch(index);
                Navigator.of(context).pop();
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

  void deleteCatch(int index) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/delete_item.php"),
        body: {
          "userid": widget.user.id,
          "itemid": itemList[index].itemId
        }).then((response) {
      print(response.body);
      //itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
          loaduserItems();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      }
    });
  }

  Future<void> _refresh() async {
    setState(() {
      itemList.clear();
      loaduserItems();
    });
  }
}
