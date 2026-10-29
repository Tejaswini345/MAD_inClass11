import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../haunted_theme.dart';
import 'signup_screen.dart';

/// The Foyer: a tilted "admission ticket" on a black background.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.ink,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Transform.rotate(
              angle: -0.03,
              child: BrutalBox(
                color: Palette.bone,
                shadow: 10,
                padding: EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      color: Palette.pumpkin,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: const Text(
                        'ADMIT ONE CREATURE  //  NO REFUNDS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: kMono,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 1.5,
                          color: Palette.ink,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            '🦇',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 64),
                          ),
                          const SizedBox(height: 8),
                          // Typewriter title: letters appear one at a time.
                          ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 110),
                            child: AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'The Haunted Creature Registry',
                                  textAlign: TextAlign.center,
                                  textStyle: const TextStyle(
                                    fontFamily: kMono,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: Palette.ink,
                                  ),
                                  speed: const Duration(milliseconds: 90),
                                ),
                              ],
                              totalRepeatCount: 1,
                              isRepeatingAnimation: false,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            height: 3,
                            color: Palette.ink,
                          ),
                          const Text(
                            'Register your creature companion... if you dare.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: kMono,
                              fontSize: 14,
                              color: Palette.ink,
                            ),
                          ),
                          const SizedBox(height: 24),
                          BrutalButton(
                            color: Palette.slime,
                            // push(): the guest can walk back out the front door.
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignupScreen(),
                                ),
                              );
                            },
                            child: const Text('ENTER THE REGISTRY  >>'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
