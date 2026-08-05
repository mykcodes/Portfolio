import 'dart:ui'; // FIXED: Added missing import for ImageFilter functionality
import 'package:flutter/material.dart';
import '../../data/experiments_data.dart';
import 'experiment_card.dart';

class ExperimentsGrid extends StatelessWidget {
  const ExperimentsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isDesktop = screenWidth >= 1024;

    if (!isDesktop) {
      // Mobile Single-Column Fallback Configuration
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ExperimentsData.labModules.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: _LabStaggerReveal(
              index: index,
              child: ExperimentCard(experiment: ExperimentsData.labModules[index]),
            ),
          );
        },
      );
    }

    // High Fidelity Desktop Asymmetric Layout System
    final featuredModule = ExperimentsData.labModules.firstWhere((e) => e.isFeatured);
    final basicModules = ExperimentsData.labModules.where((e) => !e.isFeatured).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dominant Featured Experiment System (Left Column)
        Expanded(
          flex: 4,
          child: _LabStaggerReveal(
            index: 0,
            child: ExperimentCard(experiment: featuredModule),
          ),
        ),
        const SizedBox(width: 24),
        
        // Standard Secondary Infrastructure Stack (Right Column)
        Expanded(
          flex: 3,
          child: Column(
            children: List.generate(basicModules.length, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: index == basicModules.length - 1 ? 0.0 : 24.0),
                child: _LabStaggerReveal(
                  index: index + 1,
                  child: ExperimentCard(experiment: basicModules[index]),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _LabStaggerReveal extends StatefulWidget {
  final Widget child;
  final int index;
  const _LabStaggerReveal({required this.child, required this.index});

  @override
  State<_LabStaggerReveal> createState() => _LabStaggerRevealState();
}

class _LabStaggerRevealState extends State<_LabStaggerReveal> {
  bool _startAnim = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.index * 120), () {
      if (mounted) {
        setState(() => _startAnim = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: _startAnim ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, animChild) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 36 * (1.0 - value)),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 8.0 * (1.0 - value),
                sigmaY: 8.0 * (1.0 - value),
              ),
              child: animChild,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}