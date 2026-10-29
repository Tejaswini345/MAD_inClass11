import 'package:flutter/material.dart';

/// Neo-brutalist Halloween palette: thick ink outlines, hard offset shadows,
/// flat acid colors. No gradients, no soft blur.
class Palette {
  static const ink = Color(0xFF111111);
  static const bone = Color(0xFFF4EBD9);
  static const pumpkin = Color(0xFFFF6B1A);
  static const slime = Color(0xFFB6F23B);
  static const grape = Color(0xFF7B3FE4);
  static const blood = Color(0xFFE63946);
}

const String kMono = 'monospace';

/// Creature choices (insertion order = dropdown order).
const Map<String, String> kCreatureEmoji = {
  'Ghost': '👻',
  'Bat': '🦇',
  'Black Cat': '🐈‍⬛',
  'Pumpkin Spirit': '🎃',
  'Witch': '🧙‍♀️',
};

/// A flat box with a thick outline and a hard drop shadow.
class BrutalBox extends StatelessWidget {
  const BrutalBox({
    super.key,
    required this.child,
    this.color = Palette.bone,
    this.padding = const EdgeInsets.all(16),
    this.shadow = 6,
  });

  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;
  final double shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Palette.ink, width: 3),
        boxShadow: [
          BoxShadow(color: Palette.ink, offset: Offset(shadow, shadow)),
        ],
      ),
      child: child,
    );
  }
}

/// A button that physically "presses" into its shadow. Disabled when
/// [onPressed] is null.
class BrutalButton extends StatefulWidget {
  const BrutalButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.color = Palette.pumpkin,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final Color color;

  @override
  State<BrutalButton> createState() => _BrutalButtonState();
}

class _BrutalButtonState extends State<BrutalButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final push = (_down && enabled) ? 5.0 : 0.0;

    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _down = true) : null,
      onTapUp: enabled ? (_) => setState(() => _down = false) : null,
      onTapCancel: enabled ? () => setState(() => _down = false) : null,
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform: Matrix4.translationValues(push, push, 0),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: enabled ? widget.color : const Color(0xFFBDBDBD),
          border: Border.all(color: Palette.ink, width: 3),
          boxShadow: [
            BoxShadow(
              color: Palette.ink,
              offset: Offset(6 - push, 6 - push),
            ),
          ],
        ),
        child: DefaultTextStyle(
          style: const TextStyle(
            fontFamily: kMono,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Palette.ink,
            letterSpacing: 1,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Shared square, thick-bordered text field look.
InputDecoration hauntedInput(String label, IconData icon, {Widget? suffix}) {
  const square = BorderRadius.zero;
  OutlineInputBorder border(Color c) => OutlineInputBorder(
        borderRadius: square,
        borderSide: BorderSide(color: c, width: 3),
      );

  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(
      fontFamily: kMono,
      fontWeight: FontWeight.bold,
      color: Palette.ink,
    ),
    floatingLabelStyle: const TextStyle(
      fontFamily: kMono,
      fontWeight: FontWeight.bold,
      color: Palette.ink,
    ),
    prefixIcon: Icon(icon, color: Palette.ink),
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.white,
    border: border(Palette.ink),
    enabledBorder: border(Palette.ink),
    focusedBorder: border(Palette.pumpkin),
    errorBorder: border(Palette.blood),
    focusedErrorBorder: border(Palette.blood),
    errorStyle: const TextStyle(
      fontFamily: kMono,
      fontWeight: FontWeight.bold,
      color: Palette.blood,
    ),
  );
}
