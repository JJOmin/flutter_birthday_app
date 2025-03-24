import 'package:flutter/material.dart';

import 'package:geburtstags_app/repository/birthday.repo.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  static final routeName = (SettingsScreen).toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.settings_outlined, size: 48),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                final repo = context.read<BirthdayRepo>();
                repo.clearAll(); // ✅ sauber & ohne notifyListeners-Fehler

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Alle Geburtstage wurden zurückgesetzt.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Alles Zurücksetzen'),
            )
          ],
        ),
      ),
    );
  }
}
