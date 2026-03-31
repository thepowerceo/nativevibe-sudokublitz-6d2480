import 'package:flutter/material.dart';
import 'package:flutter_app/models/sudoku_puzzle.dart';

/// A card widget to display a Sudoku difficulty level and allow selection.
class DifficultyCard extends StatelessWidget {
  final SudokuDifficulty difficulty;
  final VoidCallback? onTap;
  final bool isLoading;

  const DifficultyCard({super.key, required this.difficulty, this.onTap, this.isLoading = false});

  String _getDifficultyText(SudokuDifficulty difficulty) {
    switch (difficulty) {
      case SudokuDifficulty.easy:
        return 'Easy';
      case SudokuDifficulty.medium:
        return 'Medium';
      case SudokuDifficulty.hard:
        return 'Hard';
    }
  }

  Color _getDifficultyColor(BuildContext context, SudokuDifficulty difficulty) {
    switch (difficulty) {
      case SudokuDifficulty.easy:
        return Colors.green;
      case SudokuDifficulty.medium:
        return Colors.orange;
      case SudokuDifficulty.hard:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getDifficultyColor(context, difficulty);
    final text = _getDifficultyText(difficulty);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.grid_on, color: color, size: 30),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color))),
              if (isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2))
              else
                Icon(Icons.play_arrow, color: color),
            ]))));
  }
}