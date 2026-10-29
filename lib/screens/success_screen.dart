import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../haunted_theme.dart';
import 'welcome_screen.dart';

/// The Ballroom: a stamped registration certificate + confetti.
///
/// Task C, defense #1: if [userName] or [creatureType] arrives empty, the
/// screen never shows an incomplete certificate; it reroutes to the Foyer.
class SuccessScreen extends StatefulWidget {
  const SuccessScreen({
    super.key,
    required this.userName,
    required this.creatureType,
  });

  final String userName;
  final String creatureType;

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late final ConfettiController _confetti;

  bool get _hasValidData =>
      widget.userName.trim().isNotEmpty && widget.creatureType.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 3));

    if (_hasValidData) {
      _confetti.play(); // fire the cannon once, on arrival
    } else {
      // Can't navigate during initState, so wait for the first frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          (route) => false,
        );
      });
    }
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasValidData) {
      return const Scaffold(backgroundColor: Palette.ink);
    }

    final emoji = kCreatureEmoji[widget.creatureType] ?? '🎃';

    return Scaffold(
      backgroundColor: Palette.grape,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    BrutalBox(
                      color: Palette.bone,
                      shadow: 10,
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'CERTIFICATE OF REGISTRATION',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: kMono,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                              letterSpacing: 2,
                              color: Palette.ink,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            emoji,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 72),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Welcome, ${widget.userName}!',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: kMono,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Palette.ink,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            color: Palette.slime,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            child: Text(
                              'Creature registered: ${widget.creatureType}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: kMono,
                                fontWeight: FontWeight.w900,
                                color: Palette.ink,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          BrutalButton(
                            color: Palette.pumpkin,
                            onPressed: () => Navigator.popUntil(
                                context, (route) => route.isFirst),
                            child: const Text('<<  BACK TO THE FOYER'),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Transform.rotate(
                        angle: 0.2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Palette.bone,
                            border:
                                Border.all(color: Palette.blood, width: 4),
                          ),
                          child: const Text(
                            'APPROVED',
                            style: TextStyle(
                              fontFamily: kMono,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: Palette.blood,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Palette.pumpkin,
                  Palette.slime,
                  Palette.bone,
                  Palette.blood,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
