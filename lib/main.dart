import 'dart:math';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'screens/dice_roll_screen.dart';
import 'screens/dice_selection_screen.dart';
import 'screens/history_screen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const HeadsUpApp(),
    ),
  );
}

class HeadsUpApp extends StatelessWidget {
  const HeadsUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HeadsUp',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedScreen = 0;
  int _selectedDie = 20;
  int _result = 15;
  final Random _random = Random();
  final List<RollRecord> _rolls = [];

  void _rollDice() {
    final result = _random.nextInt(_selectedDie) + 1;
    setState(() {
      _result = result;
      _rolls.insert(0, RollRecord(sides: _selectedDie, result: result));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _selectedScreen == 0
            ? null
            : IconButton(
                tooltip: 'Back to roll',
                onPressed: () => _selectScreen(0),
                icon: const Icon(Icons.chevron_left),
              ),
        title: const Text('Heads Up'),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _selectedScreen,
        children: [
          DiceRollScreen(
            sides: _selectedDie,
            result: _result,
            onRoll: _rollDice,
            onSelectDie: () => _selectScreen(2),
          ),
          HistoryScreen(rolls: _rolls),
          DiceSelectionScreen(
            selectedSides: _selectedDie,
            onSelected: (sides) {
              setState(() {
                _selectedDie = sides;
                if (_result > sides) {
                  _result = sides;
                }
              });
            },
            onConfirm: () {
              setState(() {
                _selectedScreen = 0;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: Row(
        children: [
          _NavigationButton(
            label: 'History',
            selected: _selectedScreen == 1,
            onPressed: () => _selectScreen(1),
          ),
          _NavigationButton(
            label: 'Dice',
            selected: _selectedScreen == 2,
            onPressed: () => _selectScreen(2),
          ),
        ],
      ),
    );
  }

  void _selectScreen(int index) {
    setState(() {
      _selectedScreen = index;
    });
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
