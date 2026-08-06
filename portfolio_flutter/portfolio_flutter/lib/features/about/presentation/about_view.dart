import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../content/portfolio_data.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 64.0),
      child: Column(
        children: [
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 1,
                color: const Color(0xFF4F8CFF).withValues(alpha: 0.5),
              ),
              const SizedBox(width: 16),
              Text(
                AboutData.sectionTitle,
                style: GoogleFonts.jetBrainsMono(
                  textStyle: const TextStyle(
                    color: Color(0xFF4F8CFF),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 40,
                height: 1,
                color: const Color(0xFF4F8CFF).withValues(alpha: 0.5),
              ),
            ],
          ),
          const SizedBox(height: 64),

          
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: _buildDossierCard(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDossierCard(BuildContext context) {
    final bool isDesktop = MediaQuery.sizeOf(context).width >= 600;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0x05FFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x14FFFFFF), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x054F8CFF),
            blurRadius: 40,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
          child: Stack(
            children: [
              
              Positioned.fill(
                child: CustomPaint(painter: _BlueprintGridPainter()),
              ),

              Padding(
                padding: EdgeInsets.all(isDesktop ? 48.0 : 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(AboutData.identificationLabel),
                    const SizedBox(height: 8),
                    Text(
                      AboutData.fullName,
                      style: GoogleFonts.geist(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: isDesktop ? 32 : 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AboutData.role,
                      style: GoogleFonts.jetBrainsMono(
                        textStyle: const TextStyle(
                          color: Color(0x99FFFFFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    _buildLabel(AboutData.missionLabel),
                    const SizedBox(height: 12),
                    Text(
                      AboutData.missionText,
                      style: GoogleFonts.plusJakartaSans(
                        textStyle: const TextStyle(
                          color: Color(0xCCFFFFFF),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel(AboutData.philosophyLabel),
                                    const SizedBox(height: 12),
                                    Text(
                                      AboutData.philosophyText,
                                      style: GoogleFonts.plusJakartaSans(
                                        textStyle: const TextStyle(
                                          color: Color(0x99FFFFFF),
                                          fontSize: 15,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w400,
                                          height: 1.6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 48),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel(AboutData.educationLabel),
                                    const SizedBox(height: 12),
                                    Text(
                                      AboutData.educationText,
                                      style: GoogleFonts.jetBrainsMono(
                                        textStyle: const TextStyle(
                                          color: Color(0xCCFFFFFF),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          height: 1.6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel(AboutData.philosophyLabel),
                                  const SizedBox(height: 12),
                                  Text(
                                    AboutData.philosophyText,
                                    style: GoogleFonts.plusJakartaSans(
                                      textStyle: const TextStyle(
                                        color: Color(0x99FFFFFF),
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w400,
                                        height: 1.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel(AboutData.educationLabel),
                                  const SizedBox(height: 12),
                                  Text(
                                    AboutData.educationText,
                                    style: GoogleFonts.jetBrainsMono(
                                      textStyle: const TextStyle(
                                        color: Color(0xCCFFFFFF),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        height: 1.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.jetBrainsMono(
        textStyle: const TextStyle(
          color: Color(0xFF4F8CFF),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}

class _BlueprintGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x05FFFFFF)
      ..strokeWidth = 1.0;

    final double step = 20.0;

    
    for (double i = 0; i <= size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    
    for (double i = 0; i <= size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
