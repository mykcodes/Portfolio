import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/engineering_core_widget.dart';
import 'widgets/toolbox_background.dart';

class ToolboxView extends StatefulWidget {
  const ToolboxView({super.key});

  @override
  State<ToolboxView> createState() => _ToolboxViewState();
}

class _ToolboxViewState extends State<ToolboxView> {

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
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 40.0 : 20.0, vertical: isDesktop ? 100.0 : 60.0),
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
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: isDesktop ? 44 : 28,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        letterSpacing: isDesktop ? -1.5 : -1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),

                  // The Engineering Core
                  const RepaintBoundary(
                    child: EngineeringCoreWidget(),
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
