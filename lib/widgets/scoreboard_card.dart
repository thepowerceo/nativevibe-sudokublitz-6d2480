import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/models/score.dart';

class ScoreboardCard extends StatelessWidget {
  final Score score;
  const ScoreboardCard({super.key, required this.score});

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return d.inHours > 0 ? '${d.inHours}:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${score.difficulty.name.toUpperCase()} - Score: ${score.calculatedScore}',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: cs.primary),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Icon(Icons.timer, size: 16, color: cs.onSurface.withOpacity(0.7)),
              const SizedBox(width: 4),
              Text('Time: ${_formatDuration(score.timeTaken)}', style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface.withOpacity(0.7))),
            ]),
            const SizedBox(height: 8),
            Text('Date: ${DateFormat('yyyy-MM-dd HH:mm').format(score.timestamp)}',
              style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.6))),
          ],
        ),
      ),
    );
  }
}