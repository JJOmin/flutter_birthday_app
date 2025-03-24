import 'package:flutter/material.dart';
import 'package:geburtstags_app/models/birthday.model.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class BirthdayListTile extends StatefulWidget {
  final Birthday birthday;
  final String subtitle;
  final VoidCallback onTap;
  final String extra;

  const BirthdayListTile({
    super.key,
    required this.birthday,
    required this.subtitle,
    required this.onTap,
    required this.extra,
  });

  @override
  State<BirthdayListTile> createState() => _BirthdayListTileState();
}

class _BirthdayListTileState extends State<BirthdayListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _fromAgeOffset;
  late Animation<Offset> _toAgeOffset;
  late ConfettiController _confettiController;

  bool hasExtra = false;

  @override
  void initState() {
    super.initState();
    hasExtra = widget.extra.trim().isNotEmpty;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fromAgeOffset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 2),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _toAgeOffset = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));

    if (!hasExtra) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.forward();
        _controller.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _confettiController.play();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> teile = widget.extra.split(",");

    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Card(
          elevation: 4,
          color: const Color(0xFFFFFFFF),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: hasExtra ? 1.0 : 10),
            child: ListTile(
              onTap: widget.onTap,
              leading: AvatarPlus(widget.birthday.id, height: 50, width: 50),
              title: Text(
                widget.birthday.name,
                style: hasExtra
                    ? const TextStyle(fontSize: 16)
                    : const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: hasExtra
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.subtitle),
                        Text(
                          "In ${teile[1].trim()} Tagen",
                          style: const TextStyle(
                            color: Color(0xFF699324),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    )
                  : null,
              trailing: hasExtra
                  ? Text(
                      "wird ${teile[0].trim()} Jahre",
                      style: const TextStyle(fontSize: 17),
                    )
                  : ClipRect(
                      child: SizedBox(
                        width: 50,
                        height: 40,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SlideTransition(
                              position: _fromAgeOffset,
                              child: Text(
                                widget.subtitle,
                                style: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                            SlideTransition(
                              position: _toAgeOffset,
                              child: Text(
                                "${int.parse(widget.subtitle) + 1}",
                                style: const TextStyle(
                                    fontSize: 30,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
        if (!hasExtra)
          Positioned(
            right: 0,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.orange,
                Colors.green
              ],
              createParticlePath: drawStar,
              emissionFrequency: 0.2,
              numberOfParticles: 20,
              maxBlastForce: 15,
              minBlastForce: 7,
              gravity: 0.1,
            ),
          ),
      ],
    );
  }
}

// Sternförmige Konfetti-Partikel (optional)
Path drawStar(Size size) {
  double degToRad(double deg) => deg * (pi / 180.0);

  const numberOfPoints = 5;
  final halfWidth = size.width / 2;
  final externalRadius = halfWidth;
  final internalRadius = halfWidth / 2.5;
  final degreesPerStep = degToRad(360 / numberOfPoints);
  final halfDegreesPerStep = degreesPerStep / 2;
  final path = Path();
  final fullAngle = degToRad(360);
  path.moveTo(size.width, halfWidth);

  for (double step = 0; step < fullAngle; step += degreesPerStep) {
    path.lineTo(halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step));
    path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep));
  }
  path.close();
  return path;
}
