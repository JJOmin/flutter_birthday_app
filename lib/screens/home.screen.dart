import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geburtstags_app/repository/birthday.repo.dart';
import 'package:geburtstags_app/models/birthday.model.dart';
import 'package:geburtstags_app/utils/date_time.util.dart';
import 'package:geburtstags_app/screens/birthday_screen/detail/birthday_detail.screen.dart';

import 'package:geburtstags_app/screens/widget/birthday_card_section.dart';
import 'package:geburtstags_app/screens/widget/refresh_indicator.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static final routeName = (HomeScreen).toString();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dateTimeUtil = DateTimeUtil();
  List<Birthday> nextFiveBirthdays = [];
  List<Birthday> todaysBirthdays = [];
  /*
  @override
  void initState() {
    super.initState();
    loadBirthdays();
  }

  void loadBirthdays() {
    setState(() {
      nextFiveBirthdays = BirthdayRepo.instance.getNextFiveBirthdays();
      todaysBirthdays = BirthdayRepo.instance.getTodaysBirthdays();
    });
  }
*/
  void showSnackbar(Birthday birthday) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${birthday.name} gelöscht.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final birthdayRepo = context.watch<BirthdayRepo>();
    //final birthdays = birthdayRepo().getNextFiveBirthdays();
    final nextFiveBirthdays = birthdayRepo.getNextFiveBirthdays();
    final todaysBirthdays = birthdayRepo.getTodaysBirthdays();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: CustomRefreshWrapper(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          //loadBirthdays();
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            SizedBox(height: 10),
            BirthdayCardSection(
              title: "Heutige Geburtstage 🎉🎂",
              birthdays: todaysBirthdays,
              subtitleBuilder: (birthday) =>
                  "${dateTimeUtil.getNextAge(birthday.date) - 1}",
              extraBuilder: (birthday) {
                //final date = dateTimeUtil.getNextBirthdayDate(birthday.date);
                return "";
              },
              onTap: (birthday) => () {
                Navigator.pushNamed(
                  context,
                  BirthdayDetailScreen.routeName,
                  arguments: birthday,
                ); //.then((_) => loadBirthdays());
              },
            ),
            SizedBox(height: 10),
            BirthdayCardSection(
              title: "Nächste Geburtstage 🎈",
              birthdays: nextFiveBirthdays,
              subtitleBuilder: (birthday) {
                final date = dateTimeUtil.getNextBirthdayDate(birthday.date);
                final formattedDate =
                    DateFormat('EE, d. MMM', 'de_DE').format(date);
                return "Am $formattedDate";
              },
              extraBuilder: (birthday) {
                //final date = dateTimeUtil.getNextBirthdayDate(birthday.date);
                return "${dateTimeUtil.getNextAge(birthday.date)}, ${dateTimeUtil.getDaysLeft(birthday.date)}";
              },
              onTap: (birthday) => () {
                Navigator.pushNamed(
                  context,
                  BirthdayDetailScreen.routeName,
                  arguments: birthday,
                ); //.then((_) => //loadBirthdays());
              },
            ),
          ],
        ),
      ),
    );
  }
}
