import 'package:flutter/material.dart';
import 'dart:async';
import '../models/question.dart';
import '../models/leaderboard_entry.dart';
import '../data/dummy_data.dart';
import '../widgets/option_button.dart';
import 'result_screen.dart';

class TimerQuizScreen extends StatefulWidget {
  final String playerName;

  const TimerQuizScreen({Key? key, required this.playerName}) : super(key: key);

  @override
  State<TimerQuizScreen> createState() => _TimerQuizScreenState();
}

class _TimerQuizScreenState extends State<TimerQuizScreen> {
  int currentRound = 0;
  final List<String> rounds = [
    'Indonesia',
    'Inggris',
    'Matematika',
  ];
  List<Question> questions = [];
  List<String?> userAnswers = [];
  int currentQuestionIndex = 0;
  int totalScore = 0;
  Timer? countdownTimer;
  int timeLeft = 60;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRound();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadRound() async {
    setState(() => isLoading = true);
    
    final loadedQuestions = await DummyData.instance.getQuestionsByCategory(rounds[currentRound]);
    
    setState(() {
      questions = List.from(loadedQuestions)..shuffle();
      userAnswers = List.filled(questions.length, null);
      currentQuestionIndex = 0;
      timeLeft = 60;
      isLoading = false;
    });
    
    _startTimer();
  }

  void _startTimer() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (timeLeft > 0) {
            timeLeft--;
          } else {
            _finishRound();
          }
        });
      }
    });
  }

  void _finishRound() {
    countdownTimer?.cancel();
    
    int roundScore = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] == questions[i].correctAnswer) {
        roundScore++;
      }
    }
    totalScore += roundScore;

    if (currentRound < rounds.length - 1) {
      setState(() => currentRound++);
      _loadRound();
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    final entry = LeaderboardEntry(
      playerName: widget.playerName,
      mode: 'Timer',
      score: totalScore,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    
    await DummyData.instance.insertScore(entry);
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            mode: 'Timer',
            score: totalScore,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Babak ${currentRound + 1}: ${rounds[currentRound]}'),
          backgroundColor: Colors.orange.shade400,
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
                      color: timeLeft <= 10 ? Colors.white : Colors.orange.shade700,
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
              LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / questions.length,
                backgroundColor: Colors.grey.shade300,
                color: Colors.orange,
              ),
              const SizedBox(height: 20),
              Text(
                'Soal ${currentQuestionIndex + 1} / ${questions.length}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                questions[currentQuestionIndex].question,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),
              Expanded(child: _buildOptions()),
              _buildNavigationButtons(),
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
          text: questions[currentQuestionIndex].getOption(option),
          isSelected: userAnswers[currentQuestionIndex] == option,
          selectedColor: Colors.orange.shade400,
          onPressed: () {
            setState(() {
              userAnswers[currentQuestionIndex] = option;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (currentQuestionIndex > 0)
          ElevatedButton.icon(
            onPressed: () {
              setState(() => currentQuestionIndex--);
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Sebelumnya'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
        if (currentQuestionIndex > 0) const Spacer(),
        ElevatedButton.icon(
          onPressed: () {
            if (currentQuestionIndex < questions.length - 1) {
              setState(() => currentQuestionIndex++);
            } else {
              _finishRound();
            }
          },
          label: Text(
            currentQuestionIndex < questions.length - 1 ? 'Berikutnya' : 'Selesai',
          ),
          icon: Icon(
            currentQuestionIndex < questions.length - 1
                ? Icons.arrow_forward
                : Icons.check,
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            backgroundColor: Colors.orange.shade400,
          ),
        ),
      ],
    );
  }
}