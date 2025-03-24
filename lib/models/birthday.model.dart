import 'package:uuid/uuid.dart';

import 'package:hive/hive.dart';

part 'birthday.model.g.dart';

@HiveType(typeId: 0)
class Birthday {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String sirname;

  @HiveField(3)
  final String emailAddress;

  @HiveField(4)
  final String phoneNumber;

  @HiveField(5)
  final String skills;

  @HiveField(6)
  final String notes;

  @HiveField(7)
  final String id;

  @HiveField(8)
  final String profileImage;

  Birthday({
    required this.id,
    required this.name,
    required this.sirname,
    required this.date,
    required this.phoneNumber,
    required this.emailAddress,
    required this.profileImage,
    required this.notes,
    required this.skills,
    //required this.zodiacSign,
  });

  // Factory-Methode mit automatischer ID und Sternzeichenberechnung
  factory Birthday.withId({
    required String name,
    required String sirname,
    required DateTime date,
    required String phoneNumber,
    required String emailAddress,
    required String profileImage,
    required String notes,
    required String skills,
  }) {
    return Birthday(
      id: const Uuid().v4(), // Generiert eine eindeutige UUID
      name: name,
      sirname: sirname,
      date: date,
      phoneNumber: phoneNumber,
      emailAddress: emailAddress,
      profileImage: profileImage,
      notes: notes,
      skills: skills,
    );
  }
}
