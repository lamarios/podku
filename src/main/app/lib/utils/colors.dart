// Generate palette from an image
import 'package:flutter/material.dart';

Color darken(Color color, [double amount = 0.2]) {
  return Color.lerp(color, Colors.black, amount)!;
}

Color lighten(Color color, [double amount = 0.2]) {
  return Color.lerp(color, Colors.white, amount)!;
}
