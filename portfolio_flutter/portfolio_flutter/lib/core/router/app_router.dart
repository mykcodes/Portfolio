import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import '../../features/home/presentation/home_view.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.homePath,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,

    errorBuilder: (context, state) => const Scaffold(
      backgroundColor: Color(0xFF050505),
      body: Center(child: Text('404 - Initialization Failed')),
    ),

    routes: <RouteBase>[
      GoRoute(
        name: AppRoutes.homeName,
        path: AppRoutes.homePath,
        builder: (context, state) => const HomeView(),
      ),
    ],
  );
}
