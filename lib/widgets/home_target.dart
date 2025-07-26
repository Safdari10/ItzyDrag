/// A widget that acts as a drag-and-drop target for matching animals to their homes.
///
/// Displays an image representing a home and accepts drag-and-drop operations
/// with a string payload (the animal name). If the dropped animal matches the
/// expected animal, the [onMatched] callback is triggered. Otherwise, a
/// "Try again!" [SnackBar] is shown.
///
/// - [homeImage]: The asset path of the home image to display.
/// - [expectedAnimal]: The name of the animal expected to be dropped.
/// - [onMatched]: Callback invoked when the correct animal is dropped.
///
/// This widget uses [DragTarget] to handle drag-and-drop logic and provides
/// visual feedback using [SnackBar] for incorrect matches.
library;

import 'package:flutter/material.dart';

class HomeTarget extends StatelessWidget {
  final String homeImage;
  final String expectedAnimal;
  final Function(String) onMatched;

  const HomeTarget({
    super.key,
    required this.homeImage,
    required this.expectedAnimal,
    required this.onMatched,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DragTarget<String>(
        builder: (context, candidateData, rejectedData) {
          return Image.asset(homeImage, width: 80, height: 80);
        },
        onAcceptWithDetails: (details) {
          if (details.data == expectedAnimal) {
            onMatched(details.data);
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Try again!')));
          }
        },
      ),
    );
  }
}
