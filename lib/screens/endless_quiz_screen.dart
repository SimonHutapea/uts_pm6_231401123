import 'package:flutter/material.dart';

class EndlessQuizScreen extends StatefulWidget {
  final String playerName;

  const EndlessQuizScreen({Key? key, required this.playerName}) : super(key: key);

  @override
  State<EndlessQuizScreen> createState() => _EndlessQuizScreenState();
}

class _EndlessQuizScreenState extends State<EndlessQuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Endless Quiz - ${widget.playerName}'),
      ),
      body: Center(
        child: Text('Endless Quiz Screen for ${widget.playerName}'),
      ),
    );
  }
}