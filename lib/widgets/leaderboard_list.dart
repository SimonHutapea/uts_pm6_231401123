import 'package:flutter/material.dart';
import '../models/leaderboard_entry.dart';

class LeaderboardList extends StatelessWidget {
  final String mode;
  final List<LeaderboardEntry> leaderboard;

  const LeaderboardList({
    Key? key,
    required this.mode,
    required this.leaderboard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              mode == 'Endless'
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
}