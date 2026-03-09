import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_blitz/providers/game_state.dart';

class NumberPad extends StatelessWidget {
  const NumberPad({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ...List.generate(9, (index) {
            final number = index + 1;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: ElevatedButton(
                    onPressed: gameState.isGameOver || gameState.selectedRow == null
                        ? null
                        : () {
                            gameState.setCell(
                              gameState.selectedRow!,
                              gameState.selectedCol!,
                              number,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      '$number',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            );
          }),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: ElevatedButton(
                  onPressed: gameState.isGameOver || gameState.selectedRow == null
                      ? null
                      : () {
                          gameState.clearCell(
                            gameState.selectedRow!,
                            gameState.selectedCol!,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: theme.colorScheme.errorContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Icon(Icons.backspace_outlined, size: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
