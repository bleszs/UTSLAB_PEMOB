import 'package:flutter/material.dart';

class QuizArtwork extends StatelessWidget {
  const QuizArtwork({super.key, required this.trophy, this.height = 240});
  final bool trophy;
  final double height;
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      height: height,
      child: Image.asset(
        trophy ? 'assets/images/trophy.png' : 'assets/images/education.png',
        fit: BoxFit.contain,
      ),
    ),
  );
}
