import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geburtstags_app/repository/birthday.repo.dart';
import 'package:geburtstags_app/models/birthday.model.dart';
import 'package:geburtstags_app/utils/date_time.util.dart';
import 'package:provider/provider.dart';

class BirthdayForm extends StatefulWidget {
  const BirthdayForm({super.key, this.birthday, this.isEdit = false});
  static final routeName = (BirthdayForm).toString();
  final Birthday? birthday;
  final bool isEdit;

  @override
  State<BirthdayForm> createState() => _BirthdayFormState();
}

class _BirthdayFormState extends State<BirthdayForm> {
  final _formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final sirnameController = TextEditingController();
  final mailController = TextEditingController();
  final _dateController = TextEditingController();
  final notesController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final zodiacSignController = TextEditingController();
  final skillsController = TextEditingController();
  DateTime? _selectedDate;
  final dateTimeUtil = DateTimeUtil();

  @override
  void initState() {
    super.initState();
    final birthday = widget.birthday;
    if (widget.isEdit && birthday != null) {
      nameController.text = birthday.name;
      sirnameController.text = birthday.sirname;
      mailController.text = birthday.emailAddress;
      phoneNumberController.text = birthday.phoneNumber;
      skillsController.text = birthday.skills;
      notesController.text = birthday.notes;
      _selectedDate = birthday.date;
      _dateController.text = DateFormat('dd.MM.yyyy').format(_selectedDate!);
    }
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    sirnameController.dispose();
    mailController.dispose();
    _dateController.dispose();
    notesController.dispose();
    phoneNumberController.dispose();
    zodiacSignController.dispose();
    skillsController.dispose();
    super.dispose();
  }

  void _saveBirthday(BuildContext context) {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final birthdayRepo = context.read<BirthdayRepo>();

      final birthday = Birthday(
        id: widget.isEdit ? widget.birthday!.id : UniqueKey().toString(),
        date: _selectedDate!,
        name: nameController.text,
        sirname: sirnameController.text,
        emailAddress: mailController.text,
        phoneNumber: phoneNumberController.text,
        skills: skillsController.text,
        notes: notesController.text,
      );

      widget.isEdit
          ? birthdayRepo.update(
              oldBirthday: widget.birthday!, newBirthday: birthday)
          : birthdayRepo.insert(birthday);

      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate = _selectedDate ?? DateTime.now();
    final DateTime firstDate = DateTime(1900);
    final DateTime lastDate = DateTime(2100);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('dd.MM.yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: const Color.fromARGB(255, 93, 158, 242),
              title: Text(
                "Birthday Editor",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
              actions: [
                TextButton(
                  child: const Text(
                    'Speichern',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => _saveBirthday(context),
                ),
              ],
              centerTitle: true,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Vorname',
                              suffixIcon: nameController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () => nameController.clear(),
                                    )
                                  : null,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Bitte Vorname eintragen";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            controller: sirnameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nachname',
                              suffixIcon: sirnameController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () =>
                                          sirnameController.clear(),
                                    )
                                  : null,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Bitte Nachname eintragen";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: "Geburtsdatum",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Bitte Geburtsdatum auswählen";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: mailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "E-Mail",
                        border: OutlineInputBorder(),
                        suffixIcon: mailController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => mailController.clear(),
                              )
                            : null,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte eine E-Mail-Adresse eingeben';
                        }
                        final emailRegex = RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

                        if (!emailRegex.hasMatch(value)) {
                          return 'Bitte eine gültige E-Mail-Adresse eingeben';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        border: OutlineInputBorder(),
                        suffixIcon: phoneNumberController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => phoneNumberController.clear(),
                              )
                            : null,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte eine Telefonnummer eingeben';
                        }
                        final phoneRegex = RegExp(r"^\+?[0-9\s\-()]+$");

                        if (!phoneRegex.hasMatch(value)) {
                          return 'Bitte eine gültige Telefonnummer eingeben';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: notesController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Notes",
                        border: OutlineInputBorder(),
                        suffixIcon: notesController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => notesController.clear(),
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
