// Generate palette from an image
import 'package:material_ui/material_ui.dart';

Color darken(Color color, [double amount = 0.2]) {
  return Color.lerp(color, Colors.black, amount)!;
}

Color lighten(Color color, [double amount = 0.2]) {
  return Color.lerp(color, Colors.white, amount)!;
}
