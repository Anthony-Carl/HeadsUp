import 'package:flutter/material.dart';

class DiceRollScreen extends StatelessWidget {
  const DiceRollScreen({
    required this.result,
    required this.onRoll,
    super.key,
  });

  final int result;
  final VoidCallback onRoll;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Roll the dice',
      onTap: onRoll,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onRoll,
        child: Center(
          child: Text(
            '$result',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
