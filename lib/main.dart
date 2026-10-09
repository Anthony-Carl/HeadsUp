import 'dart:io';
import 'dart:math';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'screens/dice_roll_screen.dart';
import 'screens/dice_selection_screen.dart';
import 'screens/history_screen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: kIsWeb && kDebugMode,
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
  int _historyVersion = 0;
  final Random _random = Random();
  late final Future<File> _historyFile = _getHistoryFile();

  Future<File> _getHistoryFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}${Platform.pathSeparator}roll_history.txt');
  }

  Future<void> _rollDice() async {
    final result = _random.nextInt(_selectedDie) + 1;
    final sides = _selectedDie;
    try {
      final file = await _historyFile;
      await file.writeAsString(
        '$sides,$result\n',
        mode: FileMode.append,
        flush: true,
      );
      if (!mounted) return;
      setState(() {
        _result = result;
        _historyVersion++;
      });
    } on FileSystemException catch (error) {
      _showHistoryError(error.message);
    } on PlatformException catch (error) {
      _showHistoryError(error.message ?? error.code);
    } on MissingPluginException catch (error) {
      _showHistoryError(error.message ?? 'Storage plugin is unavailable.');
    }
  }

  void _showHistoryError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not save roll history: $message')),
    );
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
        actions: _selectedScreen == 0
            ? [
                TextButton(
                  onPressed: () => _selectScreen(1),
                  child: const Text('History'),
                ),
              ]
            : null,
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
          FutureBuilder<File>(
            future: _historyFile,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Could not open roll history: ${snapshot.error}'),
                );
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return HistoryScreen(
                file: snapshot.data!,
                refreshVersion: _historyVersion,
              );
            },
          ),
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
    );
  }

  void _selectScreen(int index) {
    setState(() {
      _selectedScreen = index;
    });
  }
}
