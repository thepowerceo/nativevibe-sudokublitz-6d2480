import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/game_screen.dart';
import 'package:flutter_app/screens/scoreboard_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return HomeScreen();
        }),
      GoRoute(
        path: '/game',
        builder: (BuildContext context, GoRouterState state) {
          return GameScreen();
        }),
      GoRoute(
        path: '/scoreboard',
        builder: (BuildContext context, GoRouterState state) {
          return ScoreboardScreen();
        }),
    ]);
}
