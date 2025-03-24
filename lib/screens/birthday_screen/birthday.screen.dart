import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:geburtstags_app/repository/birthday.repo.dart';
import 'package:geburtstags_app/models/birthday.model.dart';
import 'package:geburtstags_app/screens/birthday_screen/detail/birthday_detail.screen.dart';
import 'package:geburtstags_app/screens/birthday_screen/detail/birthday_form.screen.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:geburtstags_app/utils/date_time.util.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key});
  static final routeName = (BirthdayScreen).toString();

  @override
  BirthdayScreenState createState() => BirthdayScreenState();
}

class BirthdayScreenState extends State<BirthdayScreen> {
  double _fabBottomPadding = 0.0;
  final dateTimeUtil = DateTimeUtil();

  void showSnackbar(BuildContext context, Birthday birthday) {
    setState(() => _fabBottomPadding = 48.0);

    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text('${birthday.name} gelöscht.'),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Rückgängig',
              textColor: Colors.blueAccent,
              onPressed: () {
                context.read<BirthdayRepo>().insert(birthday);
              },
            ),
          ),
        )
        .closed
        .then((_) => setState(() => _fabBottomPadding = 0.0));
  }

  @override
  Widget build(BuildContext context) {
    final birthdayRepo = context.watch<BirthdayRepo>();
    final birthdays = birthdayRepo.getBirthdays();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: ListView.builder(
          itemCount: birthdays.length,
          itemBuilder: (context, index) {
            final birthday = birthdays[index];
            final daysUntilBirthday = dateTimeUtil.getDaysLeft(birthday.date);
            final nextAge = dateTimeUtil.getNextAge(birthday.date);
            final formattedDate = DateFormat('EE, d. MMM yyyy', 'de_DE')
                .format(dateTimeUtil.getNextBirthdayDate(birthday.date));

            return Dismissible(
              key: ValueKey(birthday.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                birthdayRepo.delete(birthday);
                showSnackbar(context, birthday);
              },
              background: Container(
                color: Colors.redAccent,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: birthday.profileImage == null
                      ? AvatarPlus(birthday.id, width: 50, height: 50)
                      : ClipOval(
                          child: Image.network(birthday.profileImage!,
                              width: 50, height: 50, fit: BoxFit.cover)),
                  title: Text(
                    birthday.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: daysUntilBirthday < 5
                                    ? Colors.orangeAccent
                                    : Colors.blueAccent,
                                borderRadius: BorderRadius.circular(6)),
                            child: Text("$nextAge Jahre",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white)),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: daysUntilBirthday < 5
                                    ? Colors.orangeAccent
                                    : Colors.blueAccent,
                                borderRadius: BorderRadius.circular(6)),
                            child: Text("$daysUntilBirthday Tage",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white)),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => shareBirthdayAsCalendarEvent(birthday),
                        icon: Icon(Icons.adaptive.share),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      BirthdayDetailScreen.routeName,
                      arguments: birthday,
                    ).then((_) {
                      // kein loadBirthdays nötig, weil der Consumer automatisch aktualisiert
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: AnimatedPadding(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.only(bottom: _fabBottomPadding),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => const BirthdayForm(),
            ));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

Future<void> shareBirthdayAsCalendarEvent(Birthday birthday) async {
  final String icsContent = '''
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//GeburtstagsApp//DE
BEGIN:VEVENT
SUMMARY:Geburtstag von ${birthday.name} ${birthday.sirname}
DTSTART:${DateFormat('yyyyMMdd').format(birthday.date)}
DTEND:${DateFormat('yyyyMMdd').format(birthday.date)}
DESCRIPTION:Vergiss nicht, ${birthday.name} ${birthday.sirname} zum Geburtstag zu gratulieren!
BEGIN:VALARM
TRIGGER:-P1D
ACTION:DISPLAY
DESCRIPTION:Erinnerung an den Geburtstag von ${birthday.name} ${birthday.sirname}
END:VALARM
END:VEVENT
END:VCALENDAR
''';

  final Directory tempDir = await getTemporaryDirectory();
  final File icsFile =
      File('${tempDir.path}/${birthday.name}_${birthday.sirname}_birthday.ics');
  await icsFile.writeAsString(icsContent);

  Share.shareXFiles([XFile(icsFile.path)],
      text: 'Speichere ${birthday.name}s Geburtstag in deinem Kalender!');
}
