import 'package:flutter/material.dart';

class ColorPickerWidget extends StatelessWidget {
  final int? selectedColorValue;
  final ValueChanged<int?> onColorChanged;

  const ColorPickerWidget({
    super.key,
    required this.selectedColorValue,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> presetColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.brown,
      Colors.cyan,
      Colors.indigo,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Color Label',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // Auto Option
            InkWell(
              onTap: () => onColorChanged(null),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                  border: selectedColorValue == null
                      ? Border.all(color: Colors.black, width: 2)
                      : null,
                ),
                child: const Icon(
                  Icons.auto_fix_high,
                  size: 20,
                  color: Colors.black54,
                ),
              ),
            ),
            // Presets
            ...presetColors.map(
              (color) => InkWell(
                // FIX 1: Use .toARGB32() instead of .value
                onTap: () => onColorChanged(color.toARGB32()),

                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    // FIX 2: Compare using .toARGB32()
                    border: selectedColorValue == color.toARGB32()
                        ? Border.all(color: Colors.black, width: 2)
                        : null,
                  ),
                  // FIX 3: Compare using .toARGB32()
                  child: selectedColorValue == color.toARGB32()
                      ? const Icon(Icons.check, size: 20, color: Colors.white)
                      : null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
