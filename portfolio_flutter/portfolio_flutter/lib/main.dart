import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/experience/scroll_engine.dart';
import 'core/widgets/global_mouse_region.dart';

void main() {
  runApp(const MykCodesPortfolio());
}

class MykCodesPortfolio extends StatelessWidget {
  const MykCodesPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalMouseRegion(
      child: MaterialApp.router(
        title: 'MYK-CODES | Engineering Experiences',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF050505),
          useMaterial3: true,
        ),
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: const CinematicScrollBehavior(),
            child: child!,
          );
        },
        routerConfig: AppRouter.router,
      ),
    );
  }
}
