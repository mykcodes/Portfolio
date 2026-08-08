import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/controllers/experience_controller.dart';
import '../../../../core/experience/sound_engine.dart';
import '../../../../core/utils/motion_system.dart';
import '../../../../core/experience/mobile_render_engine.dart';

class MobileGlassDrawer extends StatelessWidget {
  const MobileGlassDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ExperienceController.instance,
      builder: (context, child) {
        final isOpen = ExperienceController.instance.isMobileDrawerOpen;
        final config = MobileRenderEngine.getConfig(context);

        return Stack(
          children: [
            
            IgnorePointer(
              ignoring: !isOpen,
              child: GestureDetector(
                onTap: () {
                  if (isOpen) {
                    ExperienceController.instance.toggleMobileDrawer();
                    SoundEngine.instance.playClick();
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  color: isOpen
                      ? Colors.black.withValues(alpha: 0.4)
                      : Colors.transparent,
                  width: double.infinity,
                  height: double.infinity,
                  child: isOpen
                      ? BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 8.0 * config.blurRadiusMultiplier,
                            sigmaY: 8.0 * config.blurRadiusMultiplier,
                          ),
                          child: const SizedBox.expand(),
                        )
                      : null,
                ),
              ),
            ),

            
            AnimatedPositioned(
              duration: MotionSystem.standard,
              curve: MotionSystem.deceleration,
              top: 0,
              bottom: 0,
              right: isOpen ? 0 : -300,
              width: 280,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0x1A000000),
                  border: const Border(
                    left: BorderSide(color: Color(0x1AFFFFFF), width: 1),
                  ),
                ),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 24.0 * config.blurRadiusMultiplier,
                      sigmaY: 24.0 * config.blurRadiusMultiplier,
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'SYSTEM NAVIGATION',
                                  style: GoogleFonts.geist(
                                    textStyle: const TextStyle(
                                      color: Color(0xFF4F8CFF),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: IconButton(
                                    onPressed: () {
                                      ExperienceController.instance
                                          .toggleMobileDrawer();
                                      SoundEngine.instance.playClick();
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white54,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          _DrawerItem(id: 'about', label: 'ABOUT'),
                          _DrawerItem(id: 'builds', label: 'BUILDS'),
                          _DrawerItem(id: 'journey', label: 'JOURNEY'),
                          _DrawerItem(id: 'toolbox', label: 'TOOLBOX'),
                          _DrawerItem(id: 'lab', label: 'LABORATORY'),
                          _DrawerItem(id: 'connection', label: 'TERMINAL'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String id;
  final String label;

  const _DrawerItem({required this.id, required this.label});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ExperienceController.instance,
      builder: (context, _) {
        final isActive = ExperienceController.instance.activeSection == id;

        return InkWell(
          onTap: () {
            ExperienceController.instance.toggleMobileDrawer();
            ExperienceController.instance.scrollToSection(id);
            SoundEngine.instance.playClick();
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: isActive
                      ? const Color(0xFF4F8CFF)
                      : Colors.transparent,
                  width: 3,
                ),
              ),
              color: isActive ? const Color(0x0A4F8CFF) : Colors.transparent,
            ),
            child: Row(
              children: [
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    textStyle: TextStyle(
                      color: isActive ? Colors.white : const Color(0x8CFFFFFF),
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                if (isActive) ...[
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF4F8CFF),
                    size: 16,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
