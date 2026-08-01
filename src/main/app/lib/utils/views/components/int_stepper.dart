import 'package:flutter/material.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';

class IntStepper extends StatelessWidget {
  const IntStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 20,
    this.enabled = true,
  });

  final int value;
  final bool enabled;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    final textTheme = M3ETheme.of(context).textTheme;
    final colors = M3ETheme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepButton(icon: Icons.remove, onTap: value > min && enabled ? () => onChanged(value - 1) : null),
        SizedBox(
          width: 40,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(color: !enabled ? colors.outline : null),
          ),
        ),
        _StepButton(icon: Icons.add, onTap: value < max && enabled ? () => onChanged(value + 1) : null),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final color = enabled ? M3ETheme.of(context).colorScheme.primary : M3ETheme.of(context).colorScheme.surfaceDim;

    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
    );
  }
}
