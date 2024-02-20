import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:some_game/common_widgets/common_widgets.dart';
import 'package:some_game/responsive_screen.dart';
import 'package:some_game/router.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: ResponsiveScreen(
        squarishMainArea: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/main_screen_image.jpg'),
              const SizedBox(height: 10.0),
              Transform.rotate(
                angle: -0.1,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: const Text(
                    'Fruits and numbers',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        rectangularMenuArea: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WobblyButton(
              onPressed: () {
                GoRouter.of(context).go(AppRoutes.home + AppRoutes.game);
              },
              child: const Text('Play'),
            ),
            _gap,
            WobblyButton(
              onPressed: () =>
                  GoRouter.of(context).push(AppRoutes.home + AppRoutes.setting),
              child: const Text('Settings'),
            ),
            _gap,
          ],
        ),
      ),
    );
  }

  static const _gap = SizedBox(height: 10);
}
