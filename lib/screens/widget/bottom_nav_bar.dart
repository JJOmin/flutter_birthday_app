import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final Color backgroundColor;
  final Color selectionColor;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.backgroundColor,
    required this.selectionColor,
  });

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: widget.backgroundColor,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(
                color: widget.selectionColor,
                fontWeight: FontWeight.bold,
              );
            }
            return TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            );
          },
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(20, 0, 0, 0),
              blurRadius: 3.0,
              spreadRadius: 0.5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: NavigationBar(
          backgroundColor: widget.backgroundColor,
          shadowColor: widget.backgroundColor,
          surfaceTintColor: widget.backgroundColor,
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: widget.selectedIndex == 0 ? widget.selectionColor : null,
              ),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.cake_outlined,
                color: widget.selectedIndex == 1 ? widget.selectionColor : null,
              ),
              label: 'Birthdays',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.settings_outlined,
                color: widget.selectedIndex == 2 ? widget.selectionColor : null,
              ),
              label: 'Settings',
            ),
          ],
          selectedIndex: widget.selectedIndex,
          onDestinationSelected: widget.onTabSelected,
        ),
      ),
    );
  }
}
