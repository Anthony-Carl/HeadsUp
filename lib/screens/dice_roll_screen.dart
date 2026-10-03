import 'package:flutter/material.dart';

class DiceRollScreen extends StatelessWidget {
  const DiceRollScreen({
    required this.sides,
    required this.result,
    required this.onRoll,
    required this.onSelectDie,
    super.key,
  });

  final int sides;
  final int result;
  final VoidCallback onRoll;
  final VoidCallback onSelectDie;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Roll the D$sides',
      onTap: onRoll,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onRoll,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E4E4)),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxHeight < 560;

                return Column(
                  children: [
                    const Spacer(flex: 1),
                    const Text(
                      'CURRENT DIE',
                      style: TextStyle(
                        color: Color(0xFF85898A),
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFD2D5D5)),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        'D$sides',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const Spacer(flex: 2),
                    Text(
                      '$result',
                      style: TextStyle(
                        fontSize: compact ? 96 : 120,
                        height: 1,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      width: 62,
                      height: 3,
                      margin: const EdgeInsets.only(top: 20),
                      color: Colors.black,
                    ),
                    const Spacer(flex: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: onSelectDie,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: const BorderSide(
                              color: Color(0xFF777B7B),
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Text(
                            'SELECT DICE',
                            style: TextStyle(letterSpacing: 1.2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'TAP ANYWHERE TO ROLL',
                      style: TextStyle(
                        color: Color(0xFF9A9D9D),
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
