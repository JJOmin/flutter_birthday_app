import 'package:flutter/material.dart';

class ColorPallet {
  final String id; // Unique identifier for the palette
  final String name; // Name of the color theme
  final Map<String, Color> color; // Main color
  final bool darkMode; //
  final String? beschreibung; // Optional description

  ColorPallet({
    required this.id,
    required this.name,
    required this.color,
    required this.darkMode,
    this.beschreibung,
  });

  Color get primary =>
      color["primary"] ?? const Color.fromARGB(104, 159, 243, 33);
  Color get secondary => color["secondary"] ?? Colors.grey;
  Color get background =>
      color["background"] ?? const Color.fromARGB(255, 255, 254, 254);
  Color get text1 => color["text1"] ?? Colors.black;
  Color get text2 => color["text2"] ?? Colors.black54;
}
