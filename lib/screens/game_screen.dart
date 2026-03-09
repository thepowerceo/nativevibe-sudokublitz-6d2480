import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_blitz/providers/game_state.dart';
import 'package:sudoku_blitz/widgets/sudoku_grid.dart';
import 'package:sudoku_blitz/widgets/number_pad.dart';
import 'dart:async';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final gameState = context.read<GameState>();
    if (!gameState.isPaused) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        context.read<GameState>().tick();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final theme = Theme.of(context);
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    if (gameState.isPaused && _timer?.isActive == true) {
      _timer?.cancel();
    } else if (!gameState.isPaused && _timer?.isActive != true && !gameState.isGameOver) {
      _startTimer();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Sudoku - ${gameState.difficulty.name}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Optionally pause or stop game before navigating back
            if (!gameState.isGameOver) {
              gameState.stopGame(); // Stop the game when going back
            }
            context.go('/'); // Navigate back to home
          },
        ),
        actions: [
          if (!gameState.isGameOver)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                icon: Icon(gameState.isPaused ? Icons.play_arrow : Icons.pause),
                label: Text(gameState.isPaused ? 'Resume' : 'Pause'),
                onPressed: () {
                  if (gameState.isPaused) {
                    gameState.resumeGame();
                  } else {
                    gameState.pauseGame();
                  }
                },
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: isPortrait ? _buildPortraitLayout(context) : _buildLandscapeLayout(context),
      ),
      floatingActionButton: gameState.isGameOver
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                gameState.stopGame();
                context.go('/'); // Navigate back to home after stopping
              },
              label: const Text('Stop'),
              icon: const Icon(Icons.stop),
            ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
      children: [
        _buildGameInfoBar(context),
        const Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SudokuGrid(),
            ),
          ),
        ),
        _buildActionBar(context),
        const NumberPad(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _buildGameInfoBar(context),
              const Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SudokuGrid(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionBar(context),
                const NumberPad(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameInfoBar(BuildContext context) {
    final gameState = context.watch<GameState>();
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Mistakes: ${gameState.mistakes}/3', style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold)),
          Text('Time: ${gameState.formattedTime}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    final gameState = context.read<GameState>();
    bool notesEnabled = gameState.isNotesMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            tooltip: 'Undo',
            icon: const Icon(Icons.undo),
            onPressed: gameState.canUndo ? gameState.undo : null,
          ),
          IconButton(
            tooltip: 'Redo',
            icon: const Icon(Icons.redo),
            onPressed: gameState.canRedo ? gameState.redo : null,
          ),
          TextButton.icon(
            onPressed: gameState.hintsRemaining > 0 ? gameState.useHint : null,
            icon: const Icon(Icons.lightbulb_outline),
            label: Text('Hint (${gameState.hintsRemaining})'),
          ),
          if (notesEnabled)
            IconButton(
              tooltip: 'Disable Notes',
              icon: const Icon(Icons.edit_off),
              color: Theme.of(context).colorScheme.primary,
              onPressed: gameState.toggleNotesMode,
            )
          else
            IconButton(
              tooltip: 'Enable Notes',
              icon: const Icon(Icons.edit),
              onPressed: gameState.toggleNotesMode,
            ),
        ],
      ),
    );
  }
}