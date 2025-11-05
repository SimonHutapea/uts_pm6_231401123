class LeaderboardEntry {
  final int? id;
  final String playerName;
  final String mode;
  final int score;
  final int timestamp;

  LeaderboardEntry({
    this.id,
    required this.playerName,
    required this.mode,
    required this.score,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'playerName': playerName,
      'mode': mode,
      'score': score,
      'timestamp': timestamp,
    };
  }

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      id: map['id'],
      playerName: map['playerName'],
      mode: map['mode'],
      score: map['score'],
      timestamp: map['timestamp'],
    );
  }
}