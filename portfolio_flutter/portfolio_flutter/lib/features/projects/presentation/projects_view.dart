import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/projects_data.dart';
import 'widgets/cinematic_project_card.dart';
import 'widgets/tech_blueprint_background.dart';

class ProjectsView extends StatelessWidget {
  const ProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.sizeOf(context).width >= 600;

    return Stack(
      children: [
        const Positioned.fill(
          child: TechBlueprintBackground(),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 40.0 : 20.0, vertical: isDesktop ? 80.0 : 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Premium Section Typography
                  Text(
                    'SELECTED BUILDS',
                    style: GoogleFonts.plusJakartaSans(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: isDesktop ? 42 : 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: isDesktop ? 3.0 : 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Architectural implementations and deployed systems.',
                    style: GoogleFonts.geist(
                      textStyle: const TextStyle(
                        color: Color(0x99FFFFFF),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 64),
                  
                  // Cinematic Vertical List Layout
                  Column(
                    children: ProjectsData.featuredBuilds.map((project) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 32.0),
                        child: CinematicProjectCard(project: project),
                      );
                    }).toList(),
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
