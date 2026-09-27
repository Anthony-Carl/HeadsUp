import 'package:flutter/material.dart';

class DiceSelectionScreen extends StatelessWidget {
  const DiceSelectionScreen({
    required this.selectedSides,
    required this.onSelected,
    required this.onConfirm,
    super.key,
  });

  final int selectedSides;
  final ValueChanged<int> onSelected;
  final VoidCallback onConfirm;

  static const _diceOptions = [4, 6, 8, 10, 12, 20, 100];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select a die'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final sides in _diceOptions)
                OutlinedButton(
                  onPressed: () => onSelected(sides),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: selectedSides == sides
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                  ),
                  child: Text('D$sides'),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Selected: D$selectedSides'),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onConfirm,
              child: const Text('Confirm'),
            ),
          ),
        ],
      ),
    );
  }
}
