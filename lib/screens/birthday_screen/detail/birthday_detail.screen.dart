import 'package:flutter/material.dart';
import 'package:geburtstags_app/models/birthday.model.dart';
import 'package:geburtstags_app/screens/birthday_screen/detail/birthday_form.screen.dart';
import 'package:geburtstags_app/utils/date_time.util.dart';
import 'package:intl/intl.dart';
import 'package:geburtstags_app/repository/birthday.repo.dart';
import 'package:avatar_plus/avatar_plus.dart';

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
  late Birthday birthday;
  final dateTimeUtil = DateTimeUtil();

  @override
  void initState() {
    super.initState();
    loadBirthday(); // 🎯 Beim ersten Laden direkt aus dem Repository holen
  }

  void loadBirthday() {
    setState(() {
      // 🎯 Holt den aktuellen Birthday-Eintrag aus der Liste
      birthday = BirthdayRepo.instance
          .getBirthdays()
          .firstWhere((b) => b.id == widget.birthday.id);
    });
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("${birthday.name} wirklich löschen?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Abbrechen"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("Löschen"),
              onPressed: () {
                BirthdayRepo.instance.delete(birthday);
                Navigator.pop(context); // Closes dialog
                Navigator.pop(
                    context, true); // Closes previous screen if applicable
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fullName = "${birthday.name} ${birthday.sirname}";

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
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => BirthdayForm(
                                birthday: birthday,
                                isEdit: true,
                              ),
                            ),
                          );
                          loadBirthday();
                        }
                        if (value == 1) {
                          _showAlertDialog();
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
                                      "${birthday.name} \n ${birthday.sirname}",
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
                              (birthday.profileImage == null)
                                  ? AvatarPlus(
                                      birthday.id,
                                      height:
                                          MediaQuery.of(context).size.width -
                                              300,
                                      width: MediaQuery.of(context).size.width -
                                          300,
                                    )
                                  : Image.network(
                                      birthday.profileImage!,
                                      height:
                                          MediaQuery.of(context).size.width -
                                              300,
                                      width: MediaQuery.of(context).size.width -
                                          300,
                                      fit: BoxFit.cover,
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
                                          .format(birthday.date)),
                                      const SizedBox(height: 15),
                                      const Text(
                                        'Handyummer:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(birthday.phoneNumber.toString()),
                                      const SizedBox(height: 15),
                                      const Text(
                                        'Email:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(birthday.emailAddress.toString()),
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
                                          .getCurrentAge(birthday.date)
                                          .toString()),
                                      const SizedBox(height: 15),
                                      const Text(
                                        'Sternzeichen:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(dateTimeUtil
                                          .getZodiacSign(birthday.date)
                                          .toString()),
                                      const SizedBox(height: 15),
                                      const Text(
                                        'Geburtstag in:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          "${dateTimeUtil.getDaysLeft(birthday.date).toString()} Tagen"),
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
                                      Text(birthday.skills.toString()),
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
                                      Text(birthday.notes.toString()),
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
