import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:geburtstags_app/models/birthday.model.dart';
import 'package:geburtstags_app/utils/date_time.util.dart';
import 'package:hive/hive.dart';

class BirthdayRepo extends ChangeNotifier {
  static final BirthdayRepo _birthdayRepo = BirthdayRepo._privateConstructor();

  factory BirthdayRepo() => _birthdayRepo;

  BirthdayRepo._privateConstructor() {
    _box = Hive.box<Birthday>('birthdays');

    // Füge nur Demo-Daten hinzu, wenn Box leer ist
    if (_box.isEmpty) {
      final demoBirthdays = [
        Birthday.withId(
          date: DateTime(1995, 3, 24),
          name: "Anna",
          sirname: "Schmidt",
          emailAddress: "anna.schmidt@gmail.com",
          phoneNumber: "+4915112345678",
          skills: "Klavier spielen",
          notes: "Liebt klassische Musik",
        ),
        Birthday.withId(
          date: DateTime(1988, 12, 11),
          name: "Thomas",
          sirname: "Becker",
          emailAddress: "thomas.becker@web.de",
          phoneNumber: "+4915734567890",
          skills: "Fotografie",
          notes: "Reist gerne",
        ),
        Birthday.withId(
          date: DateTime(2002, 5, 17),
          name: "Julia",
          sirname: "Wagner",
          emailAddress: "julia.wagner@yahoo.de",
          phoneNumber: "+4915145678912",
          skills: "Zeichnen",
          notes: "Vegane Ernährung",
        ),
        Birthday.withId(
          date: DateTime(1990, 9, 8),
          name: "Sebastian",
          sirname: "Keller",
          emailAddress: "sebastian.keller@outlook.com",
          phoneNumber: "+4915123456781",
          skills: "Gitarre",
          notes: "Mag Rockkonzerte",
        ),
        Birthday.withId(
          date: DateTime(1985, 2, 25),
          name: "Michaela",
          sirname: "Lorenz",
          emailAddress: "m.lorenz@web.de",
          phoneNumber: "+4915223456789",
          skills: "Backen",
          notes: "Hat eine Gluten-Unverträglichkeit",
        ),
      ];

      for (final birthday in demoBirthdays) {
        _box.put(birthday.id, birthday);
      }
    }
  }

  late Box<Birthday> _box;

  UnmodifiableListView<Birthday> getBirthdays() =>
      UnmodifiableListView(_box.values.toList());

  Birthday insert(Birthday birthday) {
    _box.put(birthday.id, birthday);
    notifyListeners();
    return birthday;
  }

  void update({required Birthday oldBirthday, required Birthday newBirthday}) {
    _box.put(newBirthday.id, newBirthday);
    notifyListeners();
  }

  void delete(Birthday birthday) {
    _box.delete(birthday.id);
    notifyListeners();
  }

  //Neue Logic hinzugefügt: abzüglich der Geburtstage die heute sind!!!
  List<Birthday> getNextFiveBirthdays() {
    final dateTimeUtil = DateTimeUtil();
    final todaysBirthdays = getTodaysBirthdays();
    var listLength = 6;
    List<Birthday> nextFiveBirthdays = _box.values
        .where((birthday) =>
            !todaysBirthdays.any((excluded) => excluded.id == birthday.id))
        .toList();

    nextFiveBirthdays.sort((a, b) => dateTimeUtil
        .getDaysLeft(a.date)
        .compareTo(dateTimeUtil.getDaysLeft(b.date)));
    if (todaysBirthdays.isNotEmpty && todaysBirthdays.length < listLength) {
      listLength = listLength - todaysBirthdays.length;
    }

    if (nextFiveBirthdays.length > listLength) {
      return nextFiveBirthdays.sublist(0, listLength);
    }

    return nextFiveBirthdays;
  }

  List<Birthday> getTodaysBirthdays() {
    final now = DateTime.now();
    return _box.values
        .where((birthday) =>
            birthday.date.day == now.day && birthday.date.month == now.month)
        .toList();
  }
}
