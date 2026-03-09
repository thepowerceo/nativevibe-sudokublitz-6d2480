import 'package:flutter/material.dart';
import 'package:sudoku_blitz/models/score.dart';
import 'package:sudoku_blitz/widgets/scoreboard_card.dart';

class ScoreboardList extends StatelessWidget {
  final List<Score> scores;
  final Score? personalBest;
  final String title;
  const ScoreboardList({super.key, required this.scores, this.personalBest, required this.title});

  @override
  Widget build(BuildContext context) {
    if (scores.isEmpty) {
      return Center(child: Text('No scores for $title yet.', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.outline)));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold))),
        Expanded(child: ListView.builder(
          itemCount: scores.length,
          itemBuilder: (context, index) => ScoreboardCard(score: scores[index]),
        )),
      ],
    );
  }
}