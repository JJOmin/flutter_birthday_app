import 'package:flutter/material.dart';
import 'package:geburtstags_app/models/birthday.model.dart';
import 'package:geburtstags_app/screens/birthday_screen/detail/birthday_form.screen.dart';
import 'package:geburtstags_app/utils/date_time.util.dart';
import 'package:intl/intl.dart';
import 'package:geburtstags_app/repository/birthday.repo.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:provider/provider.dart';

class BirthdayDetailScreen extends StatefulWidget {
  const BirthdayDetailScreen({
    required this.birthday,
    super.key,
  });

  final Birthday birthday;
  static const String routeName = "/birthday-detail";

  @override
  State<BirthdayDetailScreen> createState() => _BirthdayDetailScreenState();
}

class _BirthdayDetailScreenState extends State<BirthdayDetailScreen> {
  //late Birthday birthday;
  final dateTimeUtil = DateTimeUtil();

  void showAlertDialog(Birthday birthday) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("${birthday.name} wirklich löschen?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Abbrechen"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Löschen"),
              onPressed: () {
                context.read<BirthdayRepo>().delete(birthday);
                Navigator.pop(context); // Dialog schließen
                Navigator.pop(context, true); // ← Detail-Seite schließen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final birthdayRepo = context.watch<BirthdayRepo>();
    final birthdayDetail =
        birthdayRepo.getBirthdays().cast<Birthday?>().firstWhere(
              (b) => b!.id == widget.birthday.id,
              orElse: () => null,
            );

    if (birthdayDetail == null) {
      // Wichtig: Sofort Return, um Null-Fehler zu vermeiden!
      return const Scaffold(
        body: Center(child: Text("Geburtstag existiert nicht mehr.")),
      );
    }

    final fullName = "${birthdayDetail.name} ${birthdayDetail.sirname}";

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 93, 158, 242),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(30, 0, 0, 0),
                      blurRadius: 3.0,
                      spreadRadius: 0.5,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: AppBar(
                  actions: [
                    PopupMenuButton<int>(
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem<int>(
                            value: 1,
                            child: Text("Löschen"),
                          ),
                          const PopupMenuItem<int>(
                            value: 0,
                            child: Text("Bearbeiten"),
                          ),
                        ];
                      },
                      onSelected: (value) async {
                        if (value == 0) {
                          final updated = await Navigator.of(context).push(
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => BirthdayForm(
                                birthday: birthdayDetail,
                                isEdit: true,
                              ),
                            ),
                          );
                          if (updated == true) {
                            setState(() {
                              /*
                              birthday = context
                                  .read<BirthdayRepo>()
                                  .getBirthdays()
                                  .firstWhere(
                                      (b) => b.id == widget.birthday.id);*/
                            });
                          }
                        }
                        if (value == 1) {
                          showAlertDialog(birthdayDetail);
                        }
                      },
                    ),
                  ],
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  backgroundColor: const Color.fromARGB(255, 93, 158, 242),
                  title: Text(
                    fullName,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  centerTitle: true,
                )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          91, 33, 149, 243), // Background color
                      borderRadius:
                          BorderRadius.circular(15), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(30, 0, 0, 0),
                          blurRadius: 3.0,
                          spreadRadius: 0.5,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              //SizedBox(width: 15),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${birthdayDetail.name} \n ${birthdayDetail.sirname}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(height: 1.4),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),

                              AvatarPlus(
                                birthdayDetail.id,
                                height: MediaQuery.of(context).size.width - 300,
                                width: MediaQuery.of(context).size.width - 300,
                              )
                            ],
                          ),
                          SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                  91, 33, 149, 243), // Background color
                              borderRadius:
                                  BorderRadius.circular(20), // Rounded corners
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Geburtstag:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(DateFormat('dd.MM.yyyy')
                                          .format(birthdayDetail.date)),
                                      const SizedBox(height: 15),
                                      const Text(
                                        'Handyummer:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(birthdayDetail.phoneNumber
                                          .toString()),
                                      const SizedBox(height: 15),
                                      const Text(
                                        'Email:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(birthdayDetail.emailAddress
                                          .toString()),
                                    ],
                                  ),
                                  SizedBox(width: 35),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Alter:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(dateTimeUtil
                                          .getCurrentAge(birthdayDetail.date)
                                          .toString()),
                                      const SizedBox(height: 15),
                                      const Text(
                                        'Sternzeichen:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(dateTimeUtil
                                          .getZodiacSign(birthdayDetail.date)
                                          .toString()),
                                      const SizedBox(height: 15),
                                      const Text(
                                        'Geburtstag in:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          "${dateTimeUtil.getDaysLeft(birthdayDetail.date).toString()} Tagen"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                  91, 33, 149, 243), // Background color
                              borderRadius:
                                  BorderRadius.circular(20), // Rounded corners
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Skills:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(birthdayDetail.skills.toString()),
                                    ],
                                  ),
                                  SizedBox(width: 80),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Notizen:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(birthdayDetail.notes.toString()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  /*
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                      foregroundColor: Colors.white, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(4), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5), // Button size
                      elevation: 3, // Shadow effect
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Zurück',
                        style: TextStyle(fontSize: 16)), // Button text
                  )*/
                ],
              ),
            )
          ],
        ));
  }
}
