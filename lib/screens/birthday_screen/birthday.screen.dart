import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:geburtstags_app/repository/birthday.repo.dart';
import 'package:geburtstags_app/models/birthday.model.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:geburtstags_app/screens/birthday_screen/detail/birthday_detail.screen.dart';
import 'package:geburtstags_app/screens/birthday_screen/detail/birthday_form.screen.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:geburtstags_app/utils/date_time.util.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key});

  static final routeName = (BirthdayScreen).toString();

  @override
  BirthdayScreenState createState() => BirthdayScreenState();
}

class BirthdayScreenState extends State<BirthdayScreen> {
  List<Birthday> birthdays = [];
  double _fabBottomPadding = 0.0; // Default padding
  final dateTimeUtil = DateTimeUtil();

  @override
  void initState() {
    super.initState();
    loadBirthdays();
  }

  void loadBirthdays() {
    setState(() {
      birthdays = BirthdayRepo.instance.getBirthdays();
    });
  }

  void showSnackbar(BuildContext context, Birthday birthday) {
    setState(() {
      _fabBottomPadding = 48.0; // Move FAB up when Snackbar appears
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text('${birthday.name} gelöscht.'),
            duration: const Duration(seconds: 3),
            animation: CurvedAnimation(
              parent: AnimationController(
                duration:
                    const Duration(milliseconds: 250), // Custom animation speed
                vsync: Scaffold.of(context),
              ),
              curve: Curves.easeInOut, // Custom animation curve
            ),
            action: SnackBarAction(
              label: 'Rückgängig',
              textColor: const Color.fromARGB(255, 126, 126, 240),
              onPressed: () {
                setState(() {
                  BirthdayRepo.instance.insert(birthday);
                  loadBirthdays(); // Liste neu laden
                });
              },
            ),
          ),
        )
        .closed
        .then((_) {
      setState(() {
        _fabBottomPadding = 0.0; // Reset FAB position after Snackbar closes
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 249, 249),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
        child: ListView.builder(
          itemCount: birthdays.length,
          itemBuilder: (context, index) {
            final birthday = birthdays[index];
            final daysUntilBirthday = dateTimeUtil.getDaysLeft(birthday.date);
            final nextAge = dateTimeUtil.getNextAge(birthday.date);
            final formattedDate = DateFormat('EE, d. MMM yyyy', 'de_DE')
                .format(dateTimeUtil.getNextBirthdayDate(birthday.date));

            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                setState(() => BirthdayRepo.instance.delete(birthday));
                if (!mounted) return;
                showSnackbar(context, birthday);
              },
              child: Card(
                elevation: 3,
                color: Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  leading: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black26, width: 1),
                    ),
                    child: ClipOval(
                      child: (birthday.profileImage == null)
                          ? AvatarPlus(
                              birthday.id,
                              width: 45,
                              height: 45,
                            )
                          : Image.network(
                              birthday.profileImage!,
                              width: 45,
                              height: 45,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  title: Text(
                    birthday.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: daysUntilBirthday < 5
                                  ? Colors.orangeAccent
                                  : Colors.blueAccent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "$nextAge Jahre",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: daysUntilBirthday < 5
                                  ? Colors.orangeAccent
                                  : Colors.blueAccent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "$daysUntilBirthday Tage",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
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
                    ).then((result) {
                      loadBirthdays();
                      if (result == true && mounted) {
                        showSnackbar(context, birthday);
                      }
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
            Navigator.of(context)
                .push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const BirthdayForm(),
                ))
                .then((_) => loadBirthdays());
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
