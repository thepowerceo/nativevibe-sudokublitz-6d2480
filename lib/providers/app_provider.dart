import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sudoku_blitz/providers/game_state.dart';
import 'package:sudoku_blitz/providers/scoreboard_state.dart';
import 'package:sudoku_blitz/services/sudoku_service.dart';
import 'package:sudoku_blitz/services/scoreboard_service.dart';

/// A collection of all top-level providers for the application.
class AppProviders {
  static List<SingleChildWidget> get providers => [
        // Services that extend ChangeNotifier
        ChangeNotifierProvider<SudokuService>(
          create: (_) => SudokuService(),
        ),
        ChangeNotifierProvider<ScoreboardService>(
          create: (_) => ScoreboardService(),
        ),

        // State managers that depend on services
        ChangeNotifierProvider<GameState>(
          create: (context) => GameState(context.read<SudokuService>()),
        ),
        ChangeNotifierProvider<ScoreboardState>(
          create: (context) => ScoreboardState(context.read<ScoreboardService>()),
        ),
      ];
}