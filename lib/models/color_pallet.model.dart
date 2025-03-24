import 'package:flutter/material.dart';

class ColorPallet {
  final int id; // Unique identifier for the palette
  final String name; // Name of the color theme
  final Color color; // Main color
  final bool darkMode; //
  final String? beschreibung; // Optional description

  ColorPallet({
    required this.id,
    required this.name,
    required this.color,
    required this.darkMode,
    this.beschreibung,
  });
}
