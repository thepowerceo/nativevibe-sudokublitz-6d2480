import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sudoku_blitz/models/sudoku_puzzle.dart';

/// A service for generating and validating Sudoku puzzles.
/// Uses mock data for puzzle generation.
class SudokuService extends ChangeNotifier {
  // In a real app, this would involve a more sophisticated puzzle generation algorithm
  // or fetching from an API.

  Future<SudokuPuzzle> generatePuzzle(SudokuDifficulty difficulty) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    // Mock puzzle generation based on difficulty
    // For simplicity, we'll use predefined mock puzzles.
    // In a real app, you'd generate these dynamically.
    final List<List<int>> easyBoard = [
      [5, 3, 0, 0, 7, 0, 0, 0, 0],
      [6, 0, 0, 1, 9, 5, 0, 0, 0],
      [0, 9, 8, 0, 0, 0, 0, 6, 0],
      [8, 0, 0, 0, 6, 0, 0, 0, 3],
      [4, 0, 0, 8, 0, 3, 0, 0, 1],
      [7, 0, 0, 0, 2, 0, 0, 0, 6],
      [0, 6, 0, 0, 0, 0, 2, 8, 0],
      [0, 0, 0, 4, 1, 9, 0, 0, 5],
      [0, 0, 0, 0, 8, 0, 0, 7, 9],
    ];
    final List<List<int>> easySolution = [
      [5, 3, 4, 6, 7, 8, 9, 1, 2],
      [6, 7, 2, 1, 9, 5, 3, 4, 8],
      [1, 9, 8, 3, 4, 2, 5, 6, 7],
      [8, 5, 9, 7, 6, 1, 4, 2, 3],
      [4, 2, 6, 8, 5, 3, 7, 9, 1],
      [7, 1, 3, 9, 2, 4, 8, 5, 6],
      [9, 6, 1, 5, 3, 7, 2, 8, 4],
      [2, 8, 7, 4, 1, 9, 6, 3, 5],
      [3, 4, 5, 2, 8, 6, 1, 7, 9],
    ];

    final List<List<int>> mediumBoard = [
      [0, 0, 0, 6, 0, 0, 4, 0, 0],
      [7, 0, 0, 0, 0, 3, 6, 0, 0],
      [0, 0, 0, 0, 9, 1, 0, 8, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 5, 0, 1, 8, 0, 0, 0, 3],
      [0, 0, 0, 3, 0, 6, 0, 4, 5],
      [0, 4, 0, 2, 0, 0, 0, 6, 0],
      [9, 0, 3, 0, 0, 0, 0, 0, 0],
      [0, 2, 0, 0, 0, 0, 1, 0, 0],
    ];
    final List<List<int>> mediumSolution = [
      [1, 8, 5, 6, 7, 2, 4, 3, 9],
      [7, 9, 2, 8, 4, 3, 6, 5, 1],
      [4, 6, 3, 5, 9, 1, 7, 8, 2],
      [8, 1, 7, 4, 5, 9, 2, 6, 3],
      [2, 5, 4, 1, 8, 7, 9, 0, 3],
      [6, 3, 9, 2, 0, 6, 5, 4, 7],
      [3, 4, 1, 7, 2, 5, 8, 9, 6],
      [9, 7, 8, 3, 6, 4, 0, 1, 5],
      [5, 2, 6, 9, 1, 8, 3, 7, 4],
    ];

    final List<List<int>> hardBoard = [
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
    ]; // An empty board for hard to signify extreme difficulty
    final List<List<int>> hardSolution = List.generate(9, (_) => List.generate(9, (_) => Random().nextInt(9) + 1)); // Random solution for now

    switch (difficulty) {
      case SudokuDifficulty.easy:
        return SudokuPuzzle.create(initialBoard: easyBoard, solution: easySolution, difficulty: difficulty);
      case SudokuDifficulty.medium:
        return SudokuPuzzle.create(initialBoard: mediumBoard, solution: mediumSolution, difficulty: difficulty);
      case SudokuDifficulty.hard:
        return SudokuPuzzle.create(initialBoard: hardBoard, solution: hardSolution, difficulty: difficulty);
    }
  }

  /// Validates if the current board state matches the solution.
  bool validateSolution(List<List<int>> currentBoard, List<List<int>> solution) {
    // For a real game, this would compare currentBoard with the puzzle's solution
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (currentBoard[r][c] == 0 || currentBoard[r][c] != solution[r][c]) {
          return false;
        }
      }
    }
    return true;
  }

  /// Checks if a number can be placed at a specific cell without violating Sudoku rules.
  bool isValidMove(List<List<int>> board, int row, int col, int num) {
    // Check row
    for (int x = 0; x < 9; x++) {
      if (board[row][x] == num) return false;
    }

    // Check column
    for (int x = 0; x < 9; x++) {
      if (board[x][col] == num) return false;
    }

    // Check 3x3 box
    int startRow = row - row % 3;
    int startCol = col - col % 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i + startRow][j + startCol] == num) return false;
      }
    }
    return true;
  }
}