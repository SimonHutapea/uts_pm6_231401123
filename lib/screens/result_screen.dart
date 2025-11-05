import 'package:flutter/material.dart';
import '../models/leaderboard_entry.dart';
import '../data/dummy_data.dart';
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
                    : _buildLeaderboardList(),
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

  Widget _buildLeaderboardList() {
    if (leaderboard.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada skor di leaderboard.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: leaderboard.length,
      itemBuilder: (context, index) {
        final entry = leaderboard[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getLeaderboardColor(index),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              entry.playerName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            trailing: Text(
              widget.mode == 'Endless'
                  ? '${entry.score} detik'
                  : '${entry.score} poin',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getLeaderboardColor(int index) {
    if (index == 0) return Colors.amber;
    if (index == 1) return Colors.grey;
    if (index == 2) return Colors.brown;
    return Colors.blue;
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