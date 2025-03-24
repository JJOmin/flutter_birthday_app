import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:geburtstags_app/models/color_pallet.model.dart';

class ColorPalletRepo {
  // Singleton Pattern mit privatem Konstruktor
  ColorPalletRepo._privateConstructor() {
    _colorPallets.addAll([
      ColorPallet(
          id: 'Standard',
          name: 'Standard',
          color: {
            "primary": Color.fromARGB(255, 255, 255, 255),
            "secondary": Color.fromARGB(255, 93, 158, 242),
            "text1": Color.fromARGB(255, 0, 0, 0),
            "text2": Color.fromARGB(255, 255, 255, 255),
            "card": Color.fromARGB(255, 255, 255, 255),
            "background": Color.fromARGB(255, 249, 249, 249),
          },
          darkMode: false),
      ColorPallet(
          id: 'Standard',
          name: 'Dark Mode',
          color: {
            "primary": Color.fromARGB(255, 52, 41, 60),
            "secondary": Color.fromARGB(255, 93, 158, 242),
            "text1": Color.fromARGB(255, 0, 0, 0),
            "text2": Color.fromARGB(255, 255, 255, 255),
            "card": Color.fromARGB(255, 255, 255, 255),
            "background": Color.fromARGB(255, 0, 255, 38),
          },
          darkMode: true),
    ]);
  }

  static final ColorPalletRepo _instance =
      ColorPalletRepo._privateConstructor();

  factory ColorPalletRepo() => _instance;

  // Interne Liste der Farbpaletten
  final List<ColorPallet> _colorPallets = [];

  // Öffentlicher Zugriff als schreibgeschützte Liste
  UnmodifiableListView<ColorPallet> get colorPallets =>
      UnmodifiableListView(_colorPallets);

  // Beispielmethoden:
  void addColorPallet(ColorPallet pallet) {
    _colorPallets.add(pallet);
  }

  ColorPallet? getPalletById(String id, bool darkMode) {
    return _colorPallets.cast<ColorPallet?>().firstWhere(
          (p) =>
              p!.id.toLowerCase() == id.toLowerCase() && p.darkMode == darkMode,
          orElse: () => null,
        );
  }
}
