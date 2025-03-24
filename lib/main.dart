import 'package:flutter/material.dart';
import 'package:geburtstags_app/models/birthday.model.dart';
import 'package:geburtstags_app/screens/birthday_screen/birthday.screen.dart';
import 'package:geburtstags_app/screens/birthday_screen/detail/birthday_detail.screen.dart';
import 'package:geburtstags_app/screens/settings.screen.dart';
import 'package:geburtstags_app/screens/widget/simple_app_bar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:geburtstags_app/screens/home.screen.dart';
import 'package:geburtstags_app/screens/widget/bottom_nav_bar.dart';
import 'package:geburtstags_app/screens/birthday_screen/detail/birthday_form.screen.dart';
import 'package:provider/provider.dart';
import 'package:geburtstags_app/repository/birthday.repo.dart';

void main() {
  //runApp(const MyApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BirthdayRepo()),
      ],
      child: const MyApp(),
    ),
  );
  initializeDateFormatting('de_DE', null);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geburtstags App',
      initialRoute: HomePage.routeName,
      onGenerateRoute: (settings) {
        if (settings.name == BirthdayDetailScreen.routeName) {
          final birthday = settings.arguments as Birthday;
          return MaterialPageRoute(
            builder: (context) => BirthdayDetailScreen(birthday: birthday),
          );
        }
        return null; // Falls keine Route passt
      },
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        BirthdayScreen.routeName: (context) => const BirthdayScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
        BirthdayForm.routeName: (context) => const BirthdayForm(),
      },
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}

class HomePage extends StatefulWidget {
  static final routeName = (HomePage).toString();
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final Color backgroundColor = const Color.fromARGB(255, 255, 255, 255);
  final Color selectionColor = const Color.fromARGB(255, 93, 157, 242);
  List<String> headlines = [
    "Dashboard",
    "Birthdays",
    "Settings"
  ]; //müsste noch ausgelagert werden in model

  //Pages for IndexedStack
  final List<Widget> pages = [
    const HomeScreen(),
    const BirthdayScreen(),
    const SettingsScreen(),
  ];

  void onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: SimpleAppBar(
          headline: headlines[selectedIndex],
        ),
      ),

      //IndexedStack keeps pages alive when switching tabs
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),

      //Extracted BottomNavBar as a separate StatefulWidget
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onTabSelected: onTabSelected,
        backgroundColor: backgroundColor,
        selectionColor: selectionColor,
      ),
    );
  }
}
