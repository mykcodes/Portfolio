import 'package:flutter/material.dart';
import 'home_view.dart';

/// The entry point for the Home feature.
/// Currently acts as a simple pass-through, but serves as the future injection 
/// site for state controllers and feature-level dependencies.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // In the future, Providers or Blocs for the Home feature are initialized here.
    return const HomeView();
  }
}