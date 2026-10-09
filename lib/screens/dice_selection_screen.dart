import 'package:flutter/material.dart';

class DiceSelectionScreen extends StatefulWidget {
  const DiceSelectionScreen({
    required this.selectedSides,
    required this.onSelected,
    required this.onConfirm,
    super.key,
  });

  final int selectedSides;
  final ValueChanged<int> onSelected;
  final VoidCallback onConfirm;

  @override
  State<DiceSelectionScreen> createState() => _DiceSelectionScreenState();
}

class _DiceSelectionScreenState extends State<DiceSelectionScreen> {
  static const _diceOptions = [4, 6, 8, 10, 12, 20, 100];
  static const _backgroundColor = Color(0xFFE8E8E8);
  static const _borderColor = Color(0xFFD7DADA);

  late int _selectedSides = widget.selectedSides;

  Future<void> _chooseCustomDie() async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final sides = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom die'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Number of sides',
              hintText: 'Enter 2 to 1,000,000',
            ),
            validator: (text) {
              final value = int.tryParse(text?.trim() ?? '');
              if (value == null || value < 2 || value > 1000000) {
                return 'Enter a whole number from 2 to 1,000,000';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop(int.parse(controller.text.trim()));
              }
            },
            child: const Text('Select'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (sides != null && mounted) {
      setState(() {
        _selectedSides = sides;
      });
      widget.onSelected(sides);
    }
  }

  @override
  void didUpdateWidget(covariant DiceSelectionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedSides != widget.selectedSides) {
      _selectedSides = widget.selectedSides;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _backgroundColor,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                border: Border.all(color: _borderColor),
                borderRadius: BorderRadius.circular(7),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x18000000),
                    blurRadius: 14,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD0D3D3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const Text(
                    'DICE',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'SELECT YOUR DICE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF85898A),
                      fontSize: 11,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.05,
                    children: [
                      for (final sides in _diceOptions)
                        _DieButton(
                          label: 'D$sides',
                          selected: _selectedSides == sides,
                          onPressed: () => setState(() {
                            _selectedSides = sides;
                            widget.onSelected(sides);
                          }),
                        ),
                      _DieButton(
                        label: 'CUSTOM',
                        selected: !_diceOptions.contains(_selectedSides),
                        onPressed: _chooseCustomDie,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD5D8D8)),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CURRENT DIE',
                          style: TextStyle(
                            color: Color(0xFF85898A),
                            fontSize: 11,
                            letterSpacing: 0.7,
                          ),
                        ),
                        Center(
                          child: Text(
                            'D$_selectedSides',
                            style: const TextStyle(
                              fontSize: 48,
                              height: 1.2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: OutlinedButton(
                            onPressed: widget.onConfirm,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              side: const BorderSide(
                                color: Color(0xFF555959),
                                width: 1.5,
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            child: const Text(
                              'CONFIRM',
                              style: TextStyle(letterSpacing: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
                    child: Text(
                      'Choose the die to use for your next roll.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF747878),
                        fontSize: 13,
                        height: 1.55,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DieButton extends StatelessWidget {
  const _DieButton({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor:
            selected ? const Color(0xFFF1F1F1) : const Color(0xFFFAFAFA),
        side: BorderSide(
          color: selected ? const Color(0xFF333737) : const Color(0xFFD7DADA),
          width: selected ? 1.5 : 1,
        ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        padding: const EdgeInsets.all(4),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, letterSpacing: 0.3),
      ),
    );
  }
}
