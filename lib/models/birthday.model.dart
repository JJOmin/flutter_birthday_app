import 'package:uuid/uuid.dart';

class Birthday {
  final String id;
  final String name;
  final String sirname;
  final DateTime date;
  final String? phoneNumber;
  final String? emailAddress;
  final String? profileImage;
  final String? notes;
  final String? skills;

  Birthday({
    required this.id,
    required this.name,
    required this.sirname,
    required this.date,
    this.phoneNumber,
    this.emailAddress,
    this.profileImage,
    this.notes,
    this.skills,
    //required this.zodiacSign,
  });

  // Factory-Methode mit automatischer ID und Sternzeichenberechnung
  factory Birthday.withId({
    required String name,
    required String sirname,
    required DateTime date,
    String? phoneNumber,
    String? emailAddress,
    String? profileImage,
    String? notes,
    String? skills,
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
