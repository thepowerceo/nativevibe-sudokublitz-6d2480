import 'package:flutter/foundation.dart';
import 'package:sudoku_blitz/models/score.dart';
import 'package:sudoku_blitz/models/sudoku_puzzle.dart';
import 'package:sudoku_blitz/services/scoreboard_service.dart';
import 'package:sudoku_blitz/widgets/async_state_builder.dart'; // Import DataState

enum ScoreboardStatus implements DataState {
  initial,
  loading,
  loaded,
  error;

  @override
  bool get isLoading => this == ScoreboardStatus.loading;

  @override
  bool get isError => this == ScoreboardStatus.error;

  @override
  bool get isSuccess => this == ScoreboardStatus.loaded;

  @override
  bool get isEmpty => this == ScoreboardStatus.loaded && false; // Scoreboard data is either loaded or empty, not a distinct state
}

/// Manages the state for the scoreboard, including fetching and filtering scores.
class ScoreboardState extends ChangeNotifier {
  final ScoreboardService _scoreboardService;

  ScoreboardState(this._scoreboardService);

  List<Score> _allScores = [];
  List<Score> _globalTopScores = [];
  Map<SudokuDifficulty, List<Score>> _topScoresByDifficulty = {};
  Map<SudokuDifficulty, Score?> _userPersonalBests = {};
  ScoreboardStatus _status = ScoreboardStatus.initial;
  String? _errorMessage;

  List<Score> get allScores => _allScores;
  List<Score> get globalTopScores => _globalTopScores;
  Map<SudokuDifficulty, List<Score>> get topScoresByDifficulty => _topScoresByDifficulty;
  Map<SudokuDifficulty, Score?> get userPersonalBests => _userPersonalBests;
  ScoreboardStatus get status => _status;
  String? get errorMessage => _errorMessage;

  /// Fetches all scoreboard data.
  Future<void> fetchScoreboardData(String userId) async {
    _status = ScoreboardStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _allScores = await _scoreboardService.getAllScores();
      _globalTopScores = await _scoreboardService.getTopGlobalScores();

      for (final difficulty in SudokuDifficulty.values) {
        _topScoresByDifficulty[difficulty] = await _scoreboardService.getTopScoresByDifficulty(difficulty);
      }

      _userPersonalBests = await _scoreboardService.getUserPersonalBests(userId);

      _status = ScoreboardStatus.loaded;
    } catch (e) {
      _errorMessage = 'Failed to load scoreboard: $e';
      _status = ScoreboardStatus.error;
      debugPrint('Error fetching scoreboard data: $e');
    } finally {
      notifyListeners();
    }
  }

  /// Adds a new score to the scoreboard and refreshes the data.
  Future<void> addScore(Score score) async {
    try {
      await _scoreboardService.addScore(score);
      // After adding, refresh all data to ensure consistency
      await fetchScoreboardData(score.userId);
    } catch (e) {
      _errorMessage = 'Failed to add score: $e';
      debugPrint('Error adding score: $e');
    } finally {
      notifyListeners();
    }
  }

  /// Resets the scoreboard state.
  void resetState() {
    _allScores = [];
    _globalTopScores = [];
    _topScoresByDifficulty = {};
    _userPersonalBests = {};
    _status = ScoreboardStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }
}