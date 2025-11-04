import 'package:flutter/material.dart';

class TimerQuizScreen extends StatefulWidget {
  final String playerName;

  const TimerQuizScreen({Key? key, required this.playerName}) : super(key: key);

  @override
  State<TimerQuizScreen> createState() => _TimerQuizScreenState();
}

class _TimerQuizScreenState extends State<TimerQuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer Quiz - ${widget.playerName}'),
      ),
      body: Center(
        child: Text('Timer Quiz Screen for ${widget.playerName}'),
      ),
    );
  }
}