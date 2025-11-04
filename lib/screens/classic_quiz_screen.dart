import 'package:flutter/material.dart';

class ClassicQuizScreen extends StatefulWidget {
  final String playerName;

  const ClassicQuizScreen({Key? key, required this.playerName}) : super(key: key);

  @override
  State<ClassicQuizScreen> createState() => _ClassicQuizScreenState();
}

class _ClassicQuizScreenState extends State<ClassicQuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classic Quiz - ${widget.playerName}'),
      ),
      body: Center(
        child: Text('Classic Quiz Screen for ${widget.playerName}'),
      ),
    );
  }
}