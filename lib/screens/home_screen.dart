import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_blitz/models/sudoku_puzzle.dart';
import 'package:sudoku_blitz/providers/game_state.dart';
import 'package:sudoku_blitz/providers/scoreboard_state.dart';
import 'package:sudoku_blitz/widgets/difficulty_card.dart';
import 'package:sudoku_blitz/widgets/async_state_builder.dart';
import 'package:sudoku_blitz/widgets/scoreboard_card.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isStartingGame = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScoreboardState>().fetchScoreboardData('mock_user_id_123');
      context.read<GameState>().resetGame();
    });
  }

  Future<void> _startNewGame(SudokuDifficulty difficulty) async {
    if (_isStartingGame) return;

    setState(() {
      _isStartingGame = true;
    });

    await context.read<GameState>().newGame(difficulty);

    if (mounted) {
      final gameState = context.read<GameState>();
      if (gameState.status == GameStatus.playing) {
        context.go('/game');
      } else {
        setState(() {
          _isStartingGame = false;
        });
        if (gameState.status == GameStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(gameState.errorMessage ?? 'Failed to start game.')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scoreboardState = context.watch<ScoreboardState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SudokuBlitz'),
        centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose Difficulty',
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DifficultyCard(
                      difficulty: SudokuDifficulty.easy,
                      onTap: () => _startNewGame(SudokuDifficulty.easy),
                      isLoading: _isStartingGame && context.watch<GameState>().status == GameStatus.loading),
                    DifficultyCard(
                      difficulty: SudokuDifficulty.medium,
                      onTap: () => _startNewGame(SudokuDifficulty.medium),
                      isLoading: _isStartingGame && context.watch<GameState>().status == GameStatus.loading),
                    DifficultyCard(
                      difficulty: SudokuDifficulty.hard,
                      onTap: () => _startNewGame(SudokuDifficulty.hard),
                      isLoading: _isStartingGame && context.watch<GameState>().status == GameStatus.loading),
                    const SizedBox(height: 32),
                    Text(
                      'Your Personal Best',
                      style: textTheme.headlineSmall,
                      textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    AsyncStateBuilder(
                      state: scoreboardState.status,
                      errorMessage: scoreboardState.errorMessage,
                      onRetry: () => scoreboardState.fetchScoreboardData('mock_user_id_123'),
                      builder: (context) {
                        final personalBests = scoreboardState.userPersonalBests;
                        if (personalBests.isEmpty || personalBests.values.every((score) => score == null)) {
                          return const Center(child: Text('No personal bests yet!'));
                        }
                        return Column(
                          children: SudokuDifficulty.values.map((difficulty) {
                            final score = personalBests[difficulty];
                            return score == null
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: ScoreboardCard(score: score));
                          }).toList());
                      }),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => context.go('/scoreboard'),
                      icon: const Icon(Icons.leaderboard),
                      label: const Text('View FUL Scoreboard'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)))),
                  ]))),
          ])));
  }
}
