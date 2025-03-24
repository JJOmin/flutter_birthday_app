import 'package:flutter/material.dart';
import 'package:geburtstags_app/models/birthday.model.dart';
import 'birthday_list_tile.dart';

class BirthdayCardSection extends StatelessWidget {
  final String title;
  final List<Birthday> birthdays;
  final String Function(Birthday) subtitleBuilder;
  final VoidCallback Function(Birthday) onTap;
  final String Function(Birthday) extraBuilder;

  const BirthdayCardSection(
      {super.key,
      required this.title,
      required this.birthdays,
      required this.subtitleBuilder,
      required this.onTap,
      required this.extraBuilder});

  @override
  Widget build(BuildContext context) {
    return birthdays.isEmpty
        ? const SizedBox.shrink()
        : Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text(title,
                          style: Theme.of(context).textTheme.headlineSmall)),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: birthdays.length,
                    itemBuilder: (context, index) {
                      final birthday = birthdays[index];
                      return BirthdayListTile(
                        birthday: birthday,
                        subtitle: subtitleBuilder(birthday),
                        onTap: onTap(birthday),
                        extra: extraBuilder(birthday),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
