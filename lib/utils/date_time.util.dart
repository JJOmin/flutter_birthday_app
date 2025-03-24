class DateTimeUtil {
  int getDaysLeft(DateTime birthday) {
    final currentDate = DateTime.now();
    final DateTime nextBirthday = getNextBirthdayDate(birthday);
    return nextBirthday.difference(currentDate).inDays +
        1; //letzte tag wird nicht mitgezählt
  }

  Map getTimeLeft(DateTime birthday) {
    final currentDate = DateTime.now();
    final DateTime nextBirthday = getNextBirthdayDate(birthday);
    final difference = _calculateMonthsAndDays(currentDate, nextBirthday);

    return difference;
  }

//testing
  Map<String, int> _calculateMonthsAndDays(DateTime from, DateTime to) {
    if (to.isBefore(from)) {
      final temp = from;
      from = to;
      to = temp;
    }

    int years = to.year - from.year;
    int months = to.month - from.month;
    int days = to.day - from.day;

    if (days < 0) {
      final prevMonth = DateTime(to.year, to.month, 0);
      days += prevMonth.day;
      months--;
    }

    if (months < 0) {
      months += 12;
      years--;
    }

    return {
      "years": years,
      "months": months,
      "days": days,
    };
  }

  DateTime getNextBirthdayDate(DateTime birthday) {
    final currentDate = DateTime.now();
    DateTime nextBirthday =
        DateTime(currentDate.year, birthday.month, birthday.day);

    if (nextBirthday.isBefore(currentDate) ||
        nextBirthday.isAtSameMomentAs(currentDate)) {
      nextBirthday =
          DateTime(currentDate.year + 1, birthday.month, birthday.day);
    }
    return nextBirthday;
  }

  int getCurrentAge(DateTime date) {
    final int birthYear = date.year;
    final int nextBirthdayYear = getNextBirthdayDate(date).year;
    var currentAge = (nextBirthdayYear - birthYear) - 1;
    return currentAge;
  }

  int getNextAge(DateTime date) {
    return getCurrentAge(date) + 1;
  }

  String getZodiacSign(DateTime date) {
    int day = date.day;
    int month = date.month;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      return "Widder ♈";
    }
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      return "Stier ♉";
    }
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      return "Zwillinge ♊";
    }
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      return "Krebs ♋";
    }
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      return "Löwe ♌";
    }
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      return "Jungfrau ♍";
    }
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      return "Waage ♎";
    }
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return "Skorpion ♏";
    }
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return "Schütze ♐";
    }
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return "Steinbock ♑";
    }
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return "Wassermann ♒";
    }
    return "Fische ♓";
  }
}
