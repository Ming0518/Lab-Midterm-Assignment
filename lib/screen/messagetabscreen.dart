import 'package:flutter/material.dart';
import 'package:barterlt/user.dart';

class MessageTabScreen extends StatefulWidget {
  final User user;
  const MessageTabScreen({super.key, required this.user});

  @override
  State<MessageTabScreen> createState() => _MessageTabScreenState();
}

class _MessageTabScreenState extends State<MessageTabScreen> {
  String maintitle = "Message";

  @override
  void initState() {
    super.initState();
    print("Message");
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
