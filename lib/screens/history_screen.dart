import 'dart:io';

import 'package:flutter/material.dart';

class RollRecord {
  const RollRecord({required this.sides, required this.result});

  final int sides;
  final int result;
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    required this.file,
    required this.refreshVersion,
    super.key,
  });

  final File file;
  final int refreshVersion;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<RollRecord>> _history = _readHistory();

  Future<List<RollRecord>> _readHistory() async {
    if (!await widget.file.exists()) {
      return [];
    }

    final lines = await widget.file.readAsLines();
    return [
      for (final line in lines)
        if (line.trim().isNotEmpty) _parseRecord(line),
    ].reversed.toList();
  }

  RollRecord _parseRecord(String line) {
    final parts = line.split(',');
    if (parts.length != 2) {
      throw FormatException('Invalid roll history entry: $line');
    }

    final sides = int.tryParse(parts[0]);
    final result = int.tryParse(parts[1]);
    if (sides == null ||
        result == null ||
        sides < 2 ||
        result < 1 ||
        result > sides) {
      throw FormatException('Invalid roll history entry: $line');
    }

    return RollRecord(sides: sides, result: result);
  }

  @override
  void didUpdateWidget(covariant HistoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file.path != widget.file.path ||
        oldWidget.refreshVersion != widget.refreshVersion) {
      _history = _readHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RollRecord>>(
      future: _history,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Text(
                'Roll History',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: _buildHistoryContent(snapshot),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHistoryContent(AsyncSnapshot<List<RollRecord>> snapshot) {
    if (snapshot.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Could not read roll history: ${snapshot.error}'),
        ),
      );
    }
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    final rolls = snapshot.data!;
    if (rolls.isEmpty) {
      return const Center(
        child: Text(
          'No rolls yet.',
          style: TextStyle(color: Color(0xFF777B7B)),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: rolls.length,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        color: Color(0xFFD5D8D8),
      ),
      itemBuilder: (context, index) {
        final roll = rolls[index];
        return SizedBox(
          height: 80,
          child: Row(
            children: [
              Container(
                width: 42,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD9DCDC)),
                ),
                child: Text(
                  'D${roll.sides}',
                  style: const TextStyle(
                    color: Color(0xFF696D6D),
                    fontSize: 11,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                roll.result.toString().padLeft(2, '0'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
