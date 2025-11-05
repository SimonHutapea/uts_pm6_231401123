import 'package:flutter/material.dart';
import 'classic_quiz_screen.dart';
import 'timer_quiz_screen.dart';
import 'endless_quiz_screen.dart';
import '../widgets/mode_card.dart';
import '../widgets/name_dialog.dart';

class ChooseModeScreen extends StatelessWidget {
  const ChooseModeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Pilih Mode'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(
          colors: [Colors.purple.shade100, Colors.blue.shade100],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ModeCard(
                mode: 'Classic',
                icon: Icons.library_books,
                color: Colors.green,
                onTap: () => _showEnterNameDialog(context, 'Classic'),
              ),
              const SizedBox(height: 20),
              ModeCard(
                mode: 'Timer',
                icon: Icons.timer,
                color: Colors.orange,
                onTap: () => _showEnterNameDialog(context, 'Timer'),
              ),
              const SizedBox(height: 20),
              ModeCard(
                mode: 'Endless',
                icon: Icons.all_inclusive,
                color: Colors.purple,
                onTap: () => _showEnterNameDialog(context, 'Endless'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEnterNameDialog(BuildContext context, String mode) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return NameDialog(
          mode: mode,
          onStart: (playerName) {
            Navigator.of(dialogContext).pop(); // Close dialog
            _navigateToQuiz(context, mode, playerName);
          },
        );
      },
    );
  }

  void _navigateToQuiz(BuildContext context, String mode, String playerName) {
    Widget quizScreen;
    
    switch (mode) {
      case 'Classic':
        quizScreen = ClassicQuizScreen(playerName: playerName);
        break;
      case 'Timer':
        quizScreen = TimerQuizScreen(playerName: playerName);
        break;
      case 'Endless':
        quizScreen = EndlessQuizScreen(playerName: playerName);
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => quizScreen),
    );
  }
}