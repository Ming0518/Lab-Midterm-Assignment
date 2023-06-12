import 'package:flutter/material.dart';
import 'package:barterlt/user.dart';

class RateTabScreen extends StatefulWidget {
  final User user;
  const RateTabScreen({super.key, required this.user});

  @override
  State<RateTabScreen> createState() => _RateTabScreenState();
}

class _RateTabScreenState extends State<RateTabScreen> {
  String maintitle = "Rate";

  @override
  void initState() {
    super.initState();
    print("Rate");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.user.email.toString()),
    );
  }
}
