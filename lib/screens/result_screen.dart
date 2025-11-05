import 'package:flutter/material.dart';
import '../models/leaderboard_entry.dart';
import '../data/dummy_data.dart';
import '../widgets/leaderboard_list.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  final String mode;
  final int score;

  const ResultScreen({Key? key, required this.mode, required this.score}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<LeaderboardEntry> leaderboard = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    final data = await DummyData.instance.getLeaderboard(widget.mode);
    setState(() {
      leaderboard = data;
      isLoading = false;
    });
  }

  Color _getModeColor() {
    switch (widget.mode) {
      case 'Classic':
        return Colors.green.shade400;
      case 'Timer':
        return Colors.orange.shade400;
      case 'Endless':
        return Colors.purple.shade400;
      default:
        return Colors.blue.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Hasil Mode ${widget.mode}'),
          backgroundColor: _getModeColor(),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.blue.shade100),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildScoreCard(),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Leaderboard',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : LeaderboardList(
                      mode: widget.mode,
                      leaderboard: leaderboard,
                  ),
              ),
              _buildBackButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.emoji_events,
            size: 60,
            color: _getModeColor(),
          ),
          const SizedBox(height: 10),
          const Text(
            'Score Anda',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            widget.mode == 'Endless'
                ? '${widget.score} detik'
                : '${widget.score} poin',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: _getModeColor(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        },
        icon: const Icon(Icons.home),
        label: const Text('Beranda'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: _getModeColor(),
        ),
      ),
    );
  }
}