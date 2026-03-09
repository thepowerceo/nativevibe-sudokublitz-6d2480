import 'package:flutter/foundation.dart';
import 'package:sudoku_blitz/models/sudoku_puzzle.dart';
import 'package:sudoku_blitz/services/sudoku_service.dart';

enum GameStatus { initial, loading, playing, paused, completed, error, stopped }

class _CellCoordinates {
  final int row;
  final int col;
  final int blockRow;
  final int blockCol;
  _CellCoordinates(this.row, this.col) : blockRow = row ~/ 3, blockCol = col ~/ 3;
  @override
  bool operator ==(Object other) => identical(this, other) || other is _CellCoordinates && row == other.row && col == other.col;
  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}

class _MoveRecord {
  final int row; final int col; final int oldValue; final int newValue; final int blockRow; final int blockCol;
  _MoveRecord({required this.row, required this.col, required this.oldValue, required this.newValue, required this.blockRow, required this.blockCol});
}

class GameState extends ChangeNotifier {
  final SudokuService _sudokuService;
  GameState(this._sudokuService);

  SudokuPuzzle? _currentPuzzle;
  List<List<int>>? _currentBoard;
  List<List<int>>? _initialBoard;
  GameStatus _status = GameStatus.initial;
  Duration _timeElapsed = Duration.zero;
  DateTime? _startTime;
  String? _errorMessage;
  int _mistakes = 0;
  bool _isNotesMode = false;
  int _hintsRemaining = 3;
  final List<_MoveRecord> _undoStack = [];
  final List<_MoveRecord> _redoStack = [];

  SudokuPuzzle? get currentPuzzle => _currentPuzzle;
  List<List<int>>? get currentBoard => _currentBoard;
  List<List<int>>? get initialBoard => _initialBoard;
  GameStatus get status => _status;
  Duration get timeElapsed => _timeElapsed;
  String? get errorMessage => _errorMessage;
  bool get isPaused => _status == GameStatus.paused;
  bool get isGameOver => _status == GameStatus.completed || _status == GameStatus.stopped;
  SudokuDifficulty get difficulty => _currentPuzzle?.difficulty ?? SudokuDifficulty.easy;
  int get mistakes => _mistakes;
  bool get isNotesMode => _isNotesMode;
  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;
  int get hintsRemaining => _hintsRemaining;

  String get formattedTime {
    final m = _timeElapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _timeElapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return _timeElapsed.inHours > 0 ? '${_timeElapsed.inHours}:$m:$s' : '$m:$s';
  }

  void tick() { if (_status == GameStatus.playing && _startTime != null) { _timeElapsed = DateTime.now().difference(_startTime!); notifyListeners(); } }
  void toggleNotesMode() { _isNotesMode = !_isNotesMode; notifyListeners(); }

  void undo() { if (_undoStack.isEmpty || _currentBoard == null) return; final move = _undoStack.removeLast(); _currentBoard![move.row][move.col] = move.oldValue; _redoStack.add(move); notifyListeners(); }
  void redo() { if (_redoStack.isEmpty || _currentBoard == null) return; final move = _redoStack.removeLast(); _currentBoard![move.row][move.col] = move.newValue; _undoStack.add(move); notifyListeners(); }

  void useHint() {
    if (_hintsRemaining <= 0 || _currentBoard == null || _currentPuzzle == null) return;
    for (int r = 0; r < 9; r++) { for (int c = 0; c < 9; c++) { if (_currentBoard![r][c] == 0) {
      final sv = _currentPuzzle!.solution[r][c];
      _undoStack.add(_MoveRecord(row: r, col: c, oldValue: 0, newValue: sv, blockRow: r ~/ 3, blockCol: c ~/ 3));
      _redoStack.clear(); _currentBoard![r][c] = sv; _hintsRemaining--; _checkCompletion(); notifyListeners(); return;
    }}}
  }

  int? _selectedRow; int? _selectedCol;
  int? get selectedRow => _selectedRow;
  int? get selectedCol => _selectedCol;
  _CellCoordinates? get selectedCell => _selectedRow != null && _selectedCol != null ? _CellCoordinates(_selectedRow!, _selectedCol!) : null;
  List<String> get wrongCells => [];
  void selectCell(int row, int col) { _selectedRow = row; _selectedCol = col; notifyListeners(); }

  Future<void> newGame(SudokuDifficulty difficulty) async {
    _status = GameStatus.loading; _errorMessage = null; _timeElapsed = Duration.zero; _startTime = null;
    _mistakes = 0; _isNotesMode = false; _hintsRemaining = 3; _undoStack.clear(); _redoStack.clear();
    _selectedRow = null; _selectedCol = null; notifyListeners();
    try {
      final puzzle = await _sudokuService.generatePuzzle(difficulty);
      _currentPuzzle = puzzle;
      _currentBoard = puzzle.initialBoard.map((row) => List<int>.from(row)).toList();
      _initialBoard = puzzle.initialBoard.map((row) => List<int>.from(row)).toList();
      _status = GameStatus.playing; _startTime = DateTime.now();
    } catch (e) { _errorMessage = 'Failed to load puzzle: $e'; _status = GameStatus.error; }
    finally { notifyListeners(); }
  }

  void resumeGame() { if (_status == GameStatus.paused) { _status = GameStatus.playing; _startTime = DateTime.now().subtract(_timeElapsed); notifyListeners(); } }
  void pauseGame() { if (_status == GameStatus.playing) { _status = GameStatus.paused; if (_startTime != null) _timeElapsed = DateTime.now().difference(_startTime!); notifyListeners(); } }
  void stopGame() { if (_status == GameStatus.playing || _status == GameStatus.paused) { _status = GameStatus.stopped; notifyListeners(); } }
  void updateTime(Duration elapsed) { if (_status == GameStatus.playing) { _timeElapsed = elapsed; notifyListeners(); } }

  bool setCell(int row, int col, int value) {
    if (_currentBoard == null || _initialBoard == null || _status != GameStatus.playing) return false;
    if (_initialBoard![row][col] != 0) return false;
    final oldValue = _currentBoard![row][col];
    _undoStack.add(_MoveRecord(row: row, col: col, oldValue: oldValue, newValue: value, blockRow: row ~/ 3, blockCol: col ~/ 3));
    _redoStack.clear(); _currentBoard![row][col] = value;
    if (_currentPuzzle != null && _currentPuzzle!.solution[row][col] != value && value != 0) _mistakes++;
    notifyListeners(); _checkCompletion(); return true;
  }

  bool clearCell(int row, int col) {
    if (_currentBoard == null || _initialBoard == null || _status != GameStatus.playing) return false;
    if (_initialBoard![row][col] != 0) return false;
    final oldValue = _currentBoard![row][col];
    _undoStack.add(_MoveRecord(row: row, col: col, oldValue: oldValue, newValue: 0, blockRow: row ~/ 3, blockCol: col ~/ 3));
    _redoStack.clear(); _currentBoard![row][col] = 0; notifyListeners(); return true;
  }

  void _checkCompletion() {
    if (_currentPuzzle == null || _currentBoard == null) return;
    for (int r = 0; r < 9; r++) { for (int c = 0; c < 9; c++) { if (_currentBoard![r][c] == 0) return; } }
    if (_sudokuService.validateSolution(_currentBoard!, _currentPuzzle!.solution)) {
      _status = GameStatus.completed; if (_startTime != null) _timeElapsed = DateTime.now().difference(_startTime!); notifyListeners();
    }
  }

  void resetGame() {
    _currentPuzzle = null; _currentBoard = null; _initialBoard = null; _status = GameStatus.initial;
    _timeElapsed = Duration.zero; _startTime = null; _errorMessage = null; _mistakes = 0;
    _isNotesMode = false; _hintsRemaining = 3; _undoStack.clear(); _redoStack.clear();
    _selectedRow = null; _selectedCol = null; notifyListeners();
  }

  List<Map<String, int>> get mutableCells {
    if (_initialBoard == null) return [];
    List<Map<String, int>> cells = [];
    for (int r = 0; r < 9; r++) { for (int c = 0; c < 9; c++) { if (_initialBoard![r][c] == 0) cells.add({'row': r, 'col': c}); } }
    return cells;
  }
}