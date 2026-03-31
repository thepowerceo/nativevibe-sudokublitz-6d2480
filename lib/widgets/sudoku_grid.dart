import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/game_state.dart';

class SudokuGrid extends StatelessWidget {
  const SudokuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 9,
        childAspectRatio: 1.0,
        crossAxisSpacing: 1.0,
        mainAxisSpacing: 1.0,
      ),
      itemCount: 81,
      itemBuilder: (context, index) {
        final row = index ~/ 9;
        final col = index % 9;
        final cellValue = gameState.currentBoard?[row][col] ?? 0;
        final isSelected = gameState.selectedRow == row && gameState.selectedCol == col;
        final isFixed = gameState.initialBoard?[row][col] != 0;
        // USER_DECISION: Use the new conflictingCells set from GameState for visual feedback
        // ARCHITECTURE: _CellCoordinates is a private class in game_state.dart, so it cannot be directly accessed here.
        // TRADEOFF: Instead of creating a new _CellCoordinates here, we'll check if the current cell (row, col) is present in the conflictingCells set.
        final isConflicting = gameState.conflictingCells.any((coord) => coord.row == row && coord.col == col);
        final isRelated = gameState.selectedRow != null && gameState.selectedCol != null &&
            (gameState.selectedRow == row ||
                gameState.selectedCol == col ||
                (row ~/ 3 == gameState.selectedRow! ~/ 3 &&
                    col ~/ 3 == gameState.selectedCol! ~/ 3));

        return GestureDetector(
          onTap: () => gameState.selectCell(row, col),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withOpacity(0.3)
                  : isConflicting // ARCHITECTURE: Prioritize conflict highlighting over related cells
                      ? colorScheme.error.withOpacity(0.3)
                      : isRelated
                          ? colorScheme.primary.withOpacity(0.1)
                          : colorScheme.surface,
              border: Border(
                top: BorderSide(width: (row % 3 == 0 && row != 0) ? 2.0 : 0.5, color: colorScheme.onSurface.withOpacity(0.4)),
                left: BorderSide(width: (col % 3 == 0 && col != 0) ? 2.0 : 0.5, color: colorScheme.onSurface.withOpacity(0.4)),
                right: BorderSide(width: 0.5, color: colorScheme.onSurface.withOpacity(0.4)),
                bottom: BorderSide(width: 0.5, color: colorScheme.onSurface.withOpacity(0.4)),
              ),
            ),
            child: Center(
              child: Stack(
                children: [
                  if (cellValue != 0)
                    Text(
                      cellValue.toString(),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: isFixed
                            ? colorScheme.onSurface
                            : isConflicting // ARCHITECTURE: Conflicting numbers are red
                                ? colorScheme.error
                                : colorScheme.secondary,
                        fontWeight: isFixed ? FontWeight.bold : FontWeight.normal,
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}