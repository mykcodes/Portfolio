import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/skill_model.dart';
import '../data/skills_data.dart';
import 'widgets/knowledge_graph/knowledge_graph_widget.dart';
import 'widgets/skill_details_panel.dart';
import 'widgets/toolbox_background.dart';

class ToolboxView extends StatefulWidget {
  const ToolboxView({super.key});

  @override
  State<ToolboxView> createState() => _ToolboxViewState();
}

class _ToolboxViewState extends State<ToolboxView> {
  // Enforces a strict default selection framework mapped cleanly to Flutter module node data
  SkillModel? _selectedModule = SkillsData.engineeringModules.first;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isDesktop = screenWidth >= 1024;

    return Stack(
      children: [
        // Layer 1: Dedicated grid blueprint mapping system
        const ToolboxBackground(),

        // Layer 2: Main Content Layout Elements
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Identity Module Section Tag
                  Text(
                    'TOOLBOX',
                    style: GoogleFonts.geist(
                      textStyle: const TextStyle(
                        color: Color(0xFF4F8CFF),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 6.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Structured Display Typography
                  Text(
                    "Engineering Workstation.\nCore Technology Architecture Stack.",
                    style: GoogleFonts.plusJakartaSans(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        letterSpacing: -1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),

                  // Responsive Core Split Engine Configurations
                  RepaintBoundary(
                    child: isDesktop 
                        ? Row(
                            key: const ValueKey<String>('desktop_toolbox'),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 6,
                                child: SizedBox(
                                  height: 600,
                                  child: KnowledgeGraphWidget(
                                    onSkillSelected: (mod) {
                                      setState(() => _selectedModule = mod);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 48),
                              Expanded(
                                flex: 5,
                                child: _selectedModule != null 
                                    ? SkillDetailsPanel(skill: _selectedModule!)
                                    : const Center(
                                        child: Text(
                                          'Select a node to view details',
                                          style: TextStyle(color: Color(0x66FFFFFF)),
                                        ),
                                      ),
                              ),
                            ],
                          )
                        : Column(
                            key: const ValueKey<String>('mobile_toolbox'),
                            children: [
                              SizedBox(
                                height: 400,
                                child: KnowledgeGraphWidget(
                                  onSkillSelected: (mod) {
                                    setState(() => _selectedModule = mod);
                                  },
                                ),
                              ),
                              const SizedBox(height: 32),
                              if (_selectedModule != null)
                                SkillDetailsPanel(skill: _selectedModule!),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
