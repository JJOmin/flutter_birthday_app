import 'package:geburtstags_app/models/birthday.model.dart';
import 'package:geburtstags_app/utils/date_time.util.dart';

class BirthdayRepo {
  // Private Constructor
  BirthdayRepo._privateConstructor() {
    _birthdays.addAll([
      Birthday.withId(
          date: DateTime(1995, 3, 21),
          name: "Anna",
          sirname: "Schmidt",
          emailAddress: "anna.schmidt@gmail.com",
          phoneNumber: "+4915112345678",
          skills: "Klavier spielen",
          notes: "Liebt klassische Musik"),
      Birthday.withId(
          date: DateTime(1988, 12, 11),
          name: "Thomas",
          sirname: "Becker",
          emailAddress: "thomas.becker@web.de",
          phoneNumber: "+4915734567890",
          skills: "Fotografie",
          notes: "Reist gerne"),
      Birthday.withId(
          date: DateTime(2002, 5, 17),
          name: "Julia",
          sirname: "Wagner",
          emailAddress: "julia.wagner@yahoo.de",
          phoneNumber: "+4915145678912",
          skills: "Zeichnen",
          notes: "Vegane Ernährung"),
      Birthday.withId(
          date: DateTime(1990, 9, 8),
          name: "Sebastian",
          sirname: "Keller",
          emailAddress: "sebastian.keller@outlook.com",
          phoneNumber: "+4915123456781",
          skills: "Gitarre",
          notes: "Mag Rockkonzerte"),
      Birthday.withId(
          date: DateTime(1985, 2, 25),
          name: "Michaela",
          sirname: "Lorenz",
          emailAddress: "m.lorenz@web.de",
          phoneNumber: "+4915223456789",
          skills: "Backen",
          notes: "Hat eine Gluten-Unverträglichkeit"),
      Birthday.withId(
          date: DateTime(1998, 7, 14),
          name: "Fabian",
          sirname: "Richter",
          emailAddress: "fabian.richter@gmail.com",
          phoneNumber: "+4915129876543",
          skills: "Programmieren",
          notes: "Flutter-Fan"),
      Birthday.withId(
          date: DateTime(1993, 10, 22),
          name: "Laura",
          sirname: "Fischer",
          emailAddress: "laura.fischer@hotmail.de",
          phoneNumber: "+4915145671234",
          skills: "Yoga",
          notes: "Mag Meditation"),
      Birthday.withId(
          date: DateTime(1987, 4, 3),
          name: "Philipp",
          sirname: "Neumann",
          emailAddress: "philipp.neumann@gmail.com",
          phoneNumber: "+4915122233445",
          skills: "Mountainbike",
          notes: "Outdoor-Enthusiast"),
      Birthday.withId(
          date: DateTime(1991, 8, 30),
          name: "Katharina",
          sirname: "Vogel",
          emailAddress: "katharina.vogel@outlook.com",
          phoneNumber: "+4915178901234",
          skills: "Fotografie",
          notes: "Liebt Naturfotografie"),
      Birthday.withId(
          date: DateTime(1983, 6, 12),
          name: "Markus",
          sirname: "Huber",
          emailAddress: "markus.huber@web.de",
          phoneNumber: "+4915234567890",
          skills: "Schwimmen",
          notes: "Trainiert Triathlon"),
    ]);
  }

  static final BirthdayRepo _instance = BirthdayRepo._privateConstructor();
  static BirthdayRepo get instance => _instance;

  //final dateTimeUtil = DateTimeUtil();

  final List<Birthday> _birthdays = [];
  List<Birthday> getBirthdays() => _birthdays;

  Birthday insert(Birthday birthday) {
    _birthdays.add(birthday);
    return birthday;
  }

  void update({required Birthday oldBirthday, required Birthday newBirhtday}) {
    _birthdays.remove(oldBirthday);
    _birthdays.add(newBirhtday);
  }

  void delete(Birthday birthday) {
    _birthdays.remove(birthday);
  }

  //Neue Logic hinzugefügt: abzüglich der Geburtstage die heute sind!!!
  List<Birthday> getNextFiveBirthdays() {
    final dateTimeUtil = DateTimeUtil();
    final todaysBirthdays = getTodaysBirthdays();
    var listLength = 6;
    List<Birthday> nextFiveBirthdays = _birthdays
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
    List<Birthday> list = [];

    for (var i = 0; i < _birthdays.length; i++) {
      if (_birthdays[i].date.day == DateTime.now().day &&
          _birthdays[i].date.month == DateTime.now().month) {
        list.add(_birthdays[i]);
      }
    }
    return list;
  }
}
