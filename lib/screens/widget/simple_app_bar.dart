import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget {
  const SimpleAppBar({
    super.key,
    this.headline = "Headline default",
  });

  final String headline;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 93, 158, 242),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(30, 0, 0, 0),
              blurRadius: 3.0,
              spreadRadius: 0.5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, // Change back button color
          ),
          backgroundColor: const Color.fromARGB(255, 93, 158, 242),
          title: Text(
            headline,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          centerTitle: true,
        ));
  }
}
