import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/leaderboard_entry.dart';
import '../models/question.dart';

class DummyData {
  static final DummyData instance = DummyData._init();
  static Database? _database;

  DummyData._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quiz.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        question TEXT NOT NULL,
        optionA TEXT NOT NULL,
        optionB TEXT NOT NULL,
        optionC TEXT NOT NULL,
        optionD TEXT NOT NULL,
        correctAnswer TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE leaderboard (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        playerName TEXT NOT NULL,
        mode TEXT NOT NULL,
        score INTEGER NOT NULL,
        timestamp INTEGER NOT NULL
      )
    ''');

    await _insertSampleQuestions(db);
  }

  Future _insertSampleQuestions(Database db) async {
    final questions = [
      Question(category: 'Indonesia', question: 'Apa ibu kota Indonesia?', optionA: 'Jakarta', optionB: 'Bandung', optionC: 'Surabaya', optionD: 'Medan', correctAnswer: 'A'),
      Question(category: 'Indonesia', question: 'Siapa proklamator kemerdekaan Indonesia?', optionA: 'Soekarno dan Hatta', optionB: 'Soeharto', optionC: 'Jokowi', optionD: 'Habibie', correctAnswer: 'A'),
      Question(category: 'Indonesia', question: 'Bahasa resmi Indonesia adalah?', optionA: 'Jawa', optionB: 'Sunda', optionC: 'Indonesia', optionD: 'Melayu', correctAnswer: 'C'),
      Question(category: 'Indonesia', question: 'Pancasila memiliki berapa sila?', optionA: '3', optionB: '4', optionC: '5', optionD: '6', correctAnswer: 'C'),
      Question(category: 'Indonesia', question: 'Gunung tertinggi di Indonesia adalah?', optionA: 'Gunung Semeru', optionB: 'Gunung Merapi', optionC: 'Puncak Jaya', optionD: 'Gunung Rinjani', correctAnswer: 'C'),
      
      Question(category: 'Inggris', question: 'What is the capital of England?', optionA: 'Manchester', optionB: 'London', optionC: 'Liverpool', optionD: 'Birmingham', correctAnswer: 'B'),
      Question(category: 'Inggris', question: 'Which word is a verb?', optionA: 'Beautiful', optionB: 'Quickly', optionC: 'Run', optionD: 'Happy', correctAnswer: 'C'),
      Question(category: 'Inggris', question: 'What is the opposite of "hot"?', optionA: 'Warm', optionB: 'Cool', optionC: 'Cold', optionD: 'Freezing', correctAnswer: 'C'),
      Question(category: 'Inggris', question: 'How many letters are in the English alphabet?', optionA: '24', optionB: '25', optionC: '26', optionD: '27', correctAnswer: 'C'),
      Question(category: 'Inggris', question: 'Which is correct: "She ___ to school"?', optionA: 'go', optionB: 'goes', optionC: 'going', optionD: 'gone', correctAnswer: 'B'),
      
      Question(category: 'Matematika', question: 'Berapakah 5 + 7?', optionA: '11', optionB: '12', optionC: '13', optionD: '14', correctAnswer: 'B'),
      Question(category: 'Matematika', question: 'Berapakah 8 × 6?', optionA: '42', optionB: '46', optionC: '48', optionD: '54', correctAnswer: 'C'),
      Question(category: 'Matematika', question: 'Berapakah 100 ÷ 4?', optionA: '20', optionB: '25', optionC: '30', optionD: '35', correctAnswer: 'B'),
      Question(category: 'Matematika', question: 'Berapakah akar kuadrat dari 64?', optionA: '6', optionB: '7', optionC: '8', optionD: '9', correctAnswer: 'C'),
      Question(category: 'Matematika', question: 'Berapakah 15% dari 200?', optionA: '20', optionB: '25', optionC: '30', optionD: '35', correctAnswer: 'C'),
    ];

    for (var q in questions) {
      await db.insert('questions', q.toMap());
    }
  }

  Future<List<Question>> getQuestionsByCategory(String category) async {
    final db = await database;
    final maps = await db.query('questions', where: 'category = ?', whereArgs: [category]);
    return maps.map((map) => Question.fromMap(map)).toList();
  }

  Future<List<Question>> getAllQuestions() async {
    final db = await database;
    final maps = await db.query('questions');
    return maps.map((map) => Question.fromMap(map)).toList();
  }

  Future<int> insertScore(LeaderboardEntry entry) async {
    final db = await database;
    return await db.insert('leaderboard', entry.toMap());
  }

  Future<List<LeaderboardEntry>> getLeaderboard(String mode) async {
    final db = await database;
    final maps = await db.query(
      'leaderboard',
      where: 'mode = ?',
      whereArgs: [mode],
      orderBy: 'score DESC',
      limit: 10,
    );
    return maps.map((map) => LeaderboardEntry.fromMap(map)).toList();
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}