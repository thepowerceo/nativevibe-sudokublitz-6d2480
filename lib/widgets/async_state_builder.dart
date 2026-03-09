import 'package:flutter/material.dart';

/// Abstract interface for state enums to implement
abstract class DataState {
  bool get isLoading;
  bool get isError;
  bool get isSuccess;
  bool get isEmpty;
}

/// A builder widget that handles loading/error/success states from a DataState enum.
class AsyncStateBuilder extends StatelessWidget {
  final DataState state;
  final String? errorMessage;
  final Widget Function(BuildContext context) builder;
  final VoidCallback? onRetry;

  const AsyncStateBuilder({
    super.key,
    required this.state,
    this.errorMessage,
    required this.builder,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.isError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 48),
              const SizedBox(height: 16),
              Text(
                'An error occurred',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage ?? 'Unknown error',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (onRetry != null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  onPressed: onRetry,
                  label: const Text('Retry'),
                ),
            ],
          ),
        ),
      );
    }
    if (state.isSuccess) {
      return builder(context);
    }
    // initial state
    return const SizedBox.shrink();
  }
}
