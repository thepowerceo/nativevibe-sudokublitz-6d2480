import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:sudoku_blitz/models/sudoku_puzzle.dart';

/// Represents a player's score for a completed Sudoku puzzle.
@immutable
class Score {
  final String id;
  final String userId; // Could be a unique device ID or user ID if authenticated
  final SudokuDifficulty difficulty;
  final int complexity; // Number of pre-filled cells in the puzzle
  final Duration timeTaken; // Time to complete the puzzle
  final int calculatedScore; // complexity * (max_time - time_taken)
  final DateTime timestamp;

  Score({
    required this.id,
    required this.userId,
    required this.difficulty,
    required this.complexity,
    required this.timeTaken,
    required this.calculatedScore,
    required this.timestamp,
  });

  /// Creates a new Score from game parameters.
  factory Score.fromGameResult({
    required String userId,
    required SudokuPuzzle puzzle,
    required Duration timeTaken,
  }) {
    final uuid = Uuid();
    // Score calculation: complexity * (a constant max_time - time_taken in seconds)
    // Max time could be 1 hour (3600 seconds) for example, adjust as needed.
    // Ensure score is not negative if timeTaken is very long.
    const int maxScoreTimeSeconds = 3600; // 1 hour
    final int effectiveTimeSeconds = timeTaken.inSeconds.clamp(0, maxScoreTimeSeconds);
    final int score = puzzle.complexity * (maxScoreTimeSeconds - effectiveTimeSeconds);

    return Score(
      id: uuid.v4(),
      userId: userId,
      difficulty: puzzle.difficulty,
      complexity: puzzle.complexity,
      timeTaken: timeTaken,
      calculatedScore: score.clamp(0, 999999999), // Prevent overflow or negative scores
      timestamp: DateTime.now(),
    );
  }

  Score copyWith({
    String? id,
    String? userId,
    SudokuDifficulty? difficulty,
    int? complexity,
    Duration? timeTaken,
    int? calculatedScore,
    DateTime? timestamp,
  }) {
    return Score(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      difficulty: difficulty ?? this.difficulty,
      complexity: complexity ?? this.complexity,
      timeTaken: timeTaken ?? this.timeTaken,
      calculatedScore: calculatedScore ?? this.calculatedScore,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'difficulty': difficulty.name,
      'complexity': complexity,
      'timeTakenSeconds': timeTaken.inSeconds,
      'calculatedScore': calculatedScore,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      id: json['id'] as String,
      userId: json['userId'] as String,
      difficulty: SudokuDifficulty.values.firstWhere(
          (e) => e.name == json['difficulty'] as String),
      complexity: json['complexity'] as int,
      timeTaken: Duration(seconds: json['timeTakenSeconds'] as int),
      calculatedScore: json['calculatedScore'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Score &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          difficulty == other.difficulty &&
          complexity == other.complexity &&
          timeTaken == other.timeTaken &&
          calculatedScore == other.calculatedScore &&
          timestamp == other.timestamp);

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      difficulty.hashCode ^
      complexity.hashCode ^
      timeTaken.hashCode ^
      calculatedScore.hashCode ^
      timestamp.hashCode;

  @override
  String toString() {
    return 'Score{id: $id, userId: $userId, difficulty: $difficulty, score: $calculatedScore, time: ${timeTaken.inSeconds}s}';
  }
}