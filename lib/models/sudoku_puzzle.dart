import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

enum SudokuDifficulty {
  easy,
  medium,
  hard,
}

/// Represents a single Sudoku puzzle.
@immutable
class SudokuPuzzle {
  final String id;
  final List<List<int>> initialBoard; // 0 for empty cells
  final List<List<int>> solution; // The solved board
  final SudokuDifficulty difficulty;
  final int complexity; // Number of pre-filled cells

  SudokuPuzzle({
    required this.id,
    required this.initialBoard,
    required this.solution,
    required this.difficulty,
    required this.complexity,
  });

  /// Creates a new SudokuPuzzle with generated ID and complexity.
  factory SudokuPuzzle.create({
    required List<List<int>> initialBoard,
    required List<List<int>> solution,
    required SudokuDifficulty difficulty,
  }) {
    final uuid = Uuid();
    final complexity = initialBoard.fold<int>(0, (sum, row) => sum + row.where((cell) => cell != 0).length);
    return SudokuPuzzle(
      id: uuid.v4(),
      initialBoard: initialBoard,
      solution: solution,
      difficulty: difficulty,
      complexity: complexity,
    );
  }

  SudokuPuzzle copyWith({
    String? id,
    List<List<int>>? initialBoard,
    List<List<int>>? solution,
    SudokuDifficulty? difficulty,
    int? complexity,
  }) {
    return SudokuPuzzle(
      id: id ?? this.id,
      initialBoard: initialBoard ?? this.initialBoard,
      solution: solution ?? this.solution,
      difficulty: difficulty ?? this.difficulty,
      complexity: complexity ?? this.complexity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'initialBoard': initialBoard.map((row) => row.toList()).toList(),
      'solution': solution.map((row) => row.toList()).toList(),
      'difficulty': difficulty.name,
      'complexity': complexity,
    };
  }

  factory SudokuPuzzle.fromJson(Map<String, dynamic> json) {
    return SudokuPuzzle(
      id: json['id'] as String,
      initialBoard: (json['initialBoard'] as List)
          .map((row) => (row as List).map((e) => e as int).toList())
          .toList(),
      solution: (json['solution'] as List)
          .map((row) => (row as List).map((e) => e as int).toList())
          .toList(),
      difficulty: SudokuDifficulty.values.firstWhere(
          (e) => e.name == json['difficulty'] as String),
      complexity: json['complexity'] as int,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SudokuPuzzle &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          listEquals(initialBoard.map((e) => e.toList()).toList(), other.initialBoard.map((e) => e.toList()).toList()) &&
          listEquals(solution.map((e) => e.toList()).toList(), other.solution.map((e) => e.toList()).toList()) &&
          difficulty == other.difficulty &&
          complexity == other.complexity);

  @override
  int get hashCode =>
      id.hashCode ^
      Object.hashAll(initialBoard.expand((e) => e)) ^
      Object.hashAll(solution.expand((e) => e)) ^
      difficulty.hashCode ^
      complexity.hashCode;

  @override
  String toString() {
    return 'SudokuPuzzle{id: $id, difficulty: $difficulty, complexity: $complexity}';
  }
}
