import 'package:flutter/material.dart';
import '../widgets/leaderboard_list.dart';
import '../models/leaderboard_entry.dart';
import '../data/dummy_data.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int currentModeIndex = 0;
  final List<String> modes = [
    'Classic',
    'Timer',
    'Endless',
  ];
  List<LeaderboardEntry> leaderboard = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    setState(() => isLoading = true);
    final data = await DummyData.instance.getLeaderboard(modes[currentModeIndex]);
    setState(() {
      leaderboard = data;
      isLoading = false;
    });
  }

  void _changeMode(int direction) {
    setState(() {
      currentModeIndex = (currentModeIndex + direction) % modes.length;
      if (currentModeIndex < 0) currentModeIndex = modes.length - 1;
    });
    _loadLeaderboard();
  }

  Color _getCurrentModeColor() {
    switch (modes[currentModeIndex]) {
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Leaderboard'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.blue.shade100),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildModeSelector(),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : LeaderboardList(
                      mode: modes[currentModeIndex],
                      leaderboard: leaderboard,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: _getCurrentModeColor(),
          ),
          onPressed: () => _changeMode(-1),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Text(
            modes[currentModeIndex],
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _getCurrentModeColor(),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            size: 30,
            color: _getCurrentModeColor(),
          ),
          onPressed: () => _changeMode(1),
        ),
      ],
    );
  }
}