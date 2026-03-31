import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/score.dart';
import 'package:flutter_app/models/sudoku_puzzle.dart';

/// A service for managing and retrieving game scores.
/// Uses mock data for score storage and retrieval.
class ScoreboardService extends ChangeNotifier {
  final List<Score> _allScores = [];

  // For mock data, we can initialize with some scores
  ScoreboardService() {
    _generateMockScores();
  }

  void _generateMockScores() {
    final now = DateTime.now();
    _allScores.addAll([
      Score.fromGameResult(
          userId: 'user1',
          puzzle: SudokuPuzzle.create(
              initialBoard: List.generate(9, (_) => List.generate(9, (_) => 0)),
              solution: List.generate(9, (_) => List.generate(9, (_) => 0)),
              difficulty: SudokuDifficulty.easy),
          timeTaken: Duration(minutes: 10, seconds: 30))
          .copyWith(calculatedScore: 1500, timestamp: now.subtract(Duration(days: 1))),
      Score.fromGameResult(
          userId: 'user2',
          puzzle: SudokuPuzzle.create(
              initialBoard: List.generate(9, (_) => List.generate(9, (_) => 0)),
              solution: List.generate(9, (_) => List.generate(9, (_) => 0)),
              difficulty: SudokuDifficulty.easy),
          timeTaken: Duration(minutes: 8, seconds: 15))
          .copyWith(calculatedScore: 1800, timestamp: now.subtract(Duration(hours: 5))),
      Score.fromGameResult(
          userId: 'user1',
          puzzle: SudokuPuzzle.create(
              initialBoard: List.generate(9, (_) => List.generate(9, (_) => 0)),
              solution: List.generate(9, (_) => List.generate(9, (_) => 0)),
              difficulty: SudokuDifficulty.medium),
          timeTaken: Duration(minutes: 25, seconds: 0))
          .copyWith(calculatedScore: 3000, timestamp: now.subtract(Duration(days: 2))),
      Score.fromGameResult(
          userId: 'user3',
          puzzle: SudokuPuzzle.create(
              initialBoard: List.generate(9, (_) => List.generate(9, (_) => 0)),
              solution: List.generate(9, (_) => List.generate(9, (_) => 0)),
              difficulty: SudokuDifficulty.hard),
          timeTaken: Duration(minutes: 45, seconds: 0))
          .copyWith(calculatedScore: 7500, timestamp: now.subtract(Duration(hours: 10))),
    ]);
  }

  /// Adds a new score to the scoreboard.
  Future<void> addScore(Score score) async {
    // Simulate API call/database write
    await Future.delayed(Duration(milliseconds: 300));
    _allScores.add(score);
    _allScores.sort((a, b) => b.calculatedScore.compareTo(a.calculatedScore)); // Keep sorted
    notifyListeners();
  }

  /// Retrieves all scores.
  Future<List<Score>> getAllScores() async {
    await Future.delayed(Duration(milliseconds: 100)); // Simulate fetch
    return List.unmodifiable(_allScores);
  }

  /// Retrieves top N scores globally.
  Future<List<Score>> getTopGlobalScores({int limit = 10}) async {
    await Future.delayed(Duration(milliseconds: 100)); // Simulate fetch
    return List.unmodifiable(_allScores.take(limit).toList());
  }

  /// Retrieves top N scores for a specific difficulty level.
  Future<List<Score>> getTopScoresByDifficulty(SudokuDifficulty difficulty, {int limit = 10}) async {
    await Future.delayed(Duration(milliseconds: 100)); // Simulate fetch
    return List.unmodifiable(
      _allScores
          .where((score) => score.difficulty == difficulty)
          .take(limit)
          .toList(),
    );
  }

  /// Retrieves a user's personal best scores for each difficulty.
  Future<Map<SudokuDifficulty, Score?>> getUserPersonalBests(String userId) async {
    await Future.delayed(Duration(milliseconds: 100)); // Simulate fetch
    final Map<SudokuDifficulty, Score?> personalBests = {};

    for (final difficulty in SudokuDifficulty.values) {
      final bestScore = _allScores
          .where((score) => score.userId == userId && score.difficulty == difficulty)
          .fold<Score?>(
            null,
            (prev, current) =>
                (prev == null || current.calculatedScore > prev.calculatedScore) ? current : prev,
          );
      personalBests[difficulty] = bestScore;
    }
    return personalBests;
  }
}