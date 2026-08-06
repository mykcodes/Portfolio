import 'package:flutter/material.dart';
import '../../../../content/sections/experiments_data.dart';
import '../../../../content/models/experiment_model.dart';
import 'experiment_capsule.dart';

class ExperimentsLayout extends StatelessWidget {
  const ExperimentsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isDesktop = screenWidth >= 1024;

    if (!isDesktop) {
      return Column(
        children: List.generate(ExperimentsData.labCapsules.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: ExperimentCapsule(
              experiment: ExperimentsData.labCapsules[index],
              index: index,
            ),
          );
        }),
      );
    }

    
    final largeCapsules = ExperimentsData.labCapsules
        .where((e) => e.size == CapsuleSize.large)
        .toList();
    final mediumCapsules = ExperimentsData.labCapsules
        .where((e) => e.size == CapsuleSize.medium)
        .toList();
    final smallCapsules = ExperimentsData.labCapsules
        .where((e) => e.size == CapsuleSize.small)
        .toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Expanded(
          flex: 5,
          child: Column(
            children: [
              if (largeCapsules.isNotEmpty)
                ExperimentCapsule(experiment: largeCapsules[0], index: 0),
              const SizedBox(height: 32),
              if (smallCapsules.isNotEmpty)
                ExperimentCapsule(experiment: smallCapsules[0], index: 3),
            ],
          ),
        ),
        const SizedBox(width: 32),
        
        Expanded(
          flex: 4,
          child: Column(
            children: [
              if (mediumCapsules.isNotEmpty)
                ExperimentCapsule(experiment: mediumCapsules[0], index: 1),
              const SizedBox(height: 32),
              if (mediumCapsules.length > 1)
                ExperimentCapsule(experiment: mediumCapsules[1], index: 2),
            ],
          ),
        ),
      ],
    );
  }
}
