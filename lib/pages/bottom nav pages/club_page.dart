import 'package:flutter/material.dart';

class ClubPage extends StatefulWidget {
  const ClubPage({super.key});

  @override
  State<ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.yellow[700],
        centerTitle: true,
        title: const Text(
          "Club",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
    ;
  }
}
