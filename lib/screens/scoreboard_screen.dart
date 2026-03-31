import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/models/score.dart';
import 'package:flutter_app/models/sudoku_puzzle.dart';
import 'package:flutter_app/providers/scoreboard_state.dart';
import 'package:flutter_app/widgets/async_state_builder.dart';
import 'package:flutter_app/widgets/scoreboard_list.dart';

class ScoreboardScreen extends StatefulWidget {
  const ScoreboardScreen({super.key});

  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  SudokuDifficulty? _selectedDifficultyFilter;

  @override
  void initState() {
    super.initState();
    // Fetch data when the screen is first loaded.
    // Using a mock user ID as per project requirements.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ScoreboardState>(context, listen: false).fetchScoreboardData('mock_user_id_123');
    });
  }

  void _retryFetch() {
    Provider.of<ScoreboardState>(context, listen: false).fetchScoreboardData('mock_user_id_123');
  }

  @override
  Widget build(BuildContext context) {
    final scoreboardState = context.watch<ScoreboardState>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scoreboard'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'), // Navigate back to home
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<SudokuDifficulty?>(
              decoration: InputDecoration(
                labelText: 'Filter by Difficulty',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.filter_list),
              ),
              value: _selectedDifficultyFilter,
              items: [
                const DropdownMenuItem<SudokuDifficulty?>(
                  value: null,
                  child: Text('All Difficulties'),
                ),
                ...SudokuDifficulty.values.map((difficulty) {
                  return DropdownMenuItem<SudokuDifficulty>(
                    value: difficulty,
                    child: Text(difficulty.name.toUpperCase()),
                  );
                }).toList(),
              ],
              onChanged: (SudokuDifficulty? newValue) {
                setState(() {
                  _selectedDifficultyFilter = newValue;
                });
              },
            ),
          ),
          Expanded(
            child: AsyncStateBuilder(
              state: scoreboardState.status,
              errorMessage: scoreboardState.errorMessage,
              onRetry: _retryFetch,
              builder: (context) {
                List<Score> scoresToShow;
                if (_selectedDifficultyFilter == null) {
                  // Show global top scores if no filter
                  scoresToShow = scoreboardState.globalTopScores;
                } else {
                  scoresToShow = scoreboardState.topScoresByDifficulty[_selectedDifficultyFilter] ?? [];
                }

                if (scoresToShow.isEmpty) {
                  return Center(
                    child: Text(
                      'No scores found for this difficulty.',
                      style: theme.textTheme.titleMedium,
                    ),
                  );
                }

                return ScoreboardList(scores: scoresToShow, title: _selectedDifficultyFilter?.name.toUpperCase() ?? 'All Difficulties');
              },
            ),
          ),
        ],
      ),
    );
  }
}