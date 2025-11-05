import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../models/question.dart';
import '../models/leaderboard_entry.dart';
import '../data/dummy_data.dart';
import '../widgets/option_button.dart';
import 'result_screen.dart';

class EndlessQuizScreen extends StatefulWidget {
  final String playerName;

  const EndlessQuizScreen({Key? key, required this.playerName}) : super(key: key);

  @override
  State<EndlessQuizScreen> createState() => _EndlessQuizScreenState();
}

class _EndlessQuizScreenState extends State<EndlessQuizScreen> {
  List<Question> allQuestions = [];
  Question? currentQuestion;
  Timer? countdownTimer;
  int timeLeft = 30;
  int totalTime = 0;
  final Random random = Random();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    allQuestions = await DummyData.instance.getAllQuestions();
    setState(() {
      isLoading = false;
    });
    _loadNextQuestion();
    _startTimer();
  }

  void _loadNextQuestion() {
    if (allQuestions.isNotEmpty) {
      setState(() {
        currentQuestion = allQuestions[random.nextInt(allQuestions.length)];
      });
    }
  }

  void _startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (timeLeft > 0) {
            timeLeft--;
            totalTime++;
          } else {
            _finishQuiz();
          }
        });
      }
    });
  }

  void _checkAnswer(String selectedAnswer) {
    if (currentQuestion != null && selectedAnswer == currentQuestion!.correctAnswer) {
      setState(() {
        timeLeft += 3;
      });
    }
    _loadNextQuestion();
  }

  Future<void> _finishQuiz() async {
    countdownTimer?.cancel();
    
    final entry = LeaderboardEntry(
      playerName: widget.playerName,
      mode: 'Endless',
      score: totalTime,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    
    await DummyData.instance.insertScore(entry);
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            mode: 'Endless',
            score: totalTime,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || currentQuestion == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Mode Endless'),
          backgroundColor: Colors.purple.shade400,
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: timeLeft <= 10 ? Colors.red : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'Waktu: ${timeLeft} detik',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: timeLeft <= 10 ? Colors.white : Colors.purple.shade700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Lama Bertahan: ${totalTime} detik',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Kategori: ${currentQuestion!.category}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                currentQuestion!.question,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(child: _buildOptions()),
              const SizedBox(height: 10),
              Text(
                'Jawaban Benar: +3 detik',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return ListView(
      children: ['A', 'B', 'C', 'D'].map((option) {
        return OptionButton(
          option: option,
          text: currentQuestion!.getOption(option),
          isSelected: false,
          selectedColor: Colors.purple.shade400,
          onPressed: () => _checkAnswer(option),
        );
      }).toList(),
    );
  }
}