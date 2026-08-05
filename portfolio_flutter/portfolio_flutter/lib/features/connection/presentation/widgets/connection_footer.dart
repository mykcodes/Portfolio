import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/connection_data.dart';

class AvailabilityIndicator extends StatefulWidget {
  const AvailabilityIndicator({super.key});

  @override
  State<AvailabilityIndicator> createState() => _AvailabilityIndicatorState();
}

class _AvailabilityIndicatorState extends State<AvailabilityIndicator> with TickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: const Color(0x14FFFFFF),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF10B981),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity((0.3 + (_pulseController.value * 0.5)).clamp(0.0, 1.0)),
                      blurRadius: 8 + (_pulseController.value * 4),
                    )
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Text(
            ConnectionData.availabilityStatus,
            style: GoogleFonts.geist(
              textStyle: const TextStyle(
                color: Color(0xCCFFFFFF),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignatureFooter extends StatelessWidget {
  const SignatureFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Designed & Engineered by',
          style: GoogleFonts.geist(
            textStyle: const TextStyle(
              color: Color(0x59FFFFFF),
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 2.0,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'MYK-CODES',
          style: GoogleFonts.plusJakartaSans(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 4.0,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Every great product begins with curiosity.',
          style: GoogleFonts.geist(
            textStyle: const TextStyle(
              color: Color(0x40FFFFFF),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
