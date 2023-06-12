import 'package:barterlt/main.dart';
import 'package:flutter/material.dart';
import 'package:barterlt/user.dart';
import 'package:barterlt/screen/itemtabscreen.dart';
import 'package:barterlt/screen/searchtabscreen.dart';
import 'package:barterlt/screen/messagetabscreen.dart';
import 'package:barterlt/screen/ratetabscreen.dart';
//import 'package:barterlt/loginscreen.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Item";

  @override
  void initState() {
    super.initState();
    print(widget.user.name);
    print("Mainscreen");
    tabchildren = [
      ItemTabScreen(
        user: widget.user,
      ),
      SearchTabScreen(user: widget.user),
      MessageTabScreen(user: widget.user),
      RateTabScreen(user: widget.user)
    ];
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(maintitle, style: const TextStyle(color: Colors.white)),
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                      TextButton(
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _goToLogin();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.green,
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.table_bar_outlined,
                ),
                label: "Item"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.saved_search,
                ),
                label: "Search"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.mail_outline,
                ),
                label: "Message"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.star_border,
                ),
                label: "Rate/Review")
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Item";
      }
      if (_currentIndex == 1) {
        maintitle = "Search";
      }
      if (_currentIndex == 2) {
        maintitle = "Message";
      }
      if (_currentIndex == 3) {
        maintitle = "Rate";
      }
    });
  }

  void _goToLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const MyApp()));
  }
}
