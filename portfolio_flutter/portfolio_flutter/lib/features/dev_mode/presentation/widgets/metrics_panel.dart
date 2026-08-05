import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/controllers/dev_mode_controller.dart';

/// Side panel displaying all engineering metrics.
/// Updates via AnimatedBuilder listening to DevModeController.
class MetricsPanel extends StatelessWidget {
  const MetricsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DevModeController.instance,
      builder: (context, _) {
        final metrics = DevModeController.instance.metricsSnapshot;

        return Container(
          width: 220,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xCC0A0A0A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0x1A4F8CFF),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'DEV MODE',
                    style: GoogleFonts.jetBrainsMono(
                      textStyle: const TextStyle(
                        color: Color(0xFF4F8CFF),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(height: 1, color: const Color(0x0DFFFFFF)),
              const SizedBox(height: 12),

              // Metric rows
              ...metrics.entries.map((entry) => _MetricRow(
                    label: entry.key,
                    value: entry.value,
                  )),
            ],
          ),
        );
      },
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetricRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              textStyle: const TextStyle(
                color: Color(0x66FFFFFF),
                fontSize: 10,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              textStyle: const TextStyle(
                color: Color(0xBBFFFFFF),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
