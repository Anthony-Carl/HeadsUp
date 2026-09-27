import 'package:flutter/material.dart';

class RollRecord {
  const RollRecord({required this.sides, required this.result});

  final int sides;
  final int result;
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({required this.rolls, super.key});

  final List<RollRecord> rolls;

  @override
  Widget build(BuildContext context) {
    if (rolls.isEmpty) {
      return const Center(child: Text('No rolls yet.'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final roll in rolls)
          ListTile(
            title: Text('D${roll.sides}'),
            trailing: Text('${roll.result}'),
          ),
      ],
    );
  }
}
