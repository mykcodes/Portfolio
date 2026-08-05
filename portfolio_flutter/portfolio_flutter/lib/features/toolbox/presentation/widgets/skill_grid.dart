import 'package:flutter/material.dart';
import '../../models/skill_model.dart';
import '../../data/skills_data.dart';
import 'skill_card.dart';

class SkillGrid extends StatelessWidget {
  final SkillModel currentSelection;
  final Function(SkillModel) onModuleSelected;

  const SkillGrid({
    super.key,
    required this.currentSelection,
    required this.onModuleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: SkillsData.engineeringModules.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) {
        final module = SkillsData.engineeringModules[index];
        return _PrecisionStaggerWrapper(
          index: index,
          child: SkillCard(
            skill: module,
            isSelected: currentSelection.name == module.name,
            onHoverEntered: () => onModuleSelected(module),
          ),
        );
      },
    );
  }
}

class _PrecisionStaggerWrapper extends StatefulWidget {
  final Widget child;
  final int index;
  const _PrecisionStaggerWrapper({required this.child, required this.index});

  @override
  State<_PrecisionStaggerWrapper> createState() => _PrecisionStaggerWrapperState();
}

class _PrecisionStaggerWrapperState extends State<_PrecisionStaggerWrapper> {
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      if (mounted) {
        setState(() => _triggered = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: _triggered ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, animChild) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 30 * (1.0 - value)),
            child: animChild,
          ),
        );
      },
      child: widget.child,
    );
  }
}