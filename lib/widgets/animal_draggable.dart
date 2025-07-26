/// A widget that displays a draggable animal image for a drag-and-drop game.
///
/// The [AnimalDraggable] widget shows an image that can be dragged by the user.
/// When the image is matched (i.e., [isMatched] is true), it displays an empty
/// space instead of the image. Otherwise, it wraps the image in a [Draggable]
/// widget, allowing it to be dragged. While dragging, a semi-transparent version
/// of the image is shown in its place, and the drag feedback is the image itself.
///
/// - [imagePath]: The asset path of the animal image to display and drag.
/// - [isMatched]: Whether the animal has already been matched. If true, the image
///   is hidden and replaced with an empty space.
library;

import 'package:flutter/material.dart';

class AnimalDraggable extends StatelessWidget {
  final String imagePath;
  final bool isMatched;

  const AnimalDraggable({
    super.key,
    required this.imagePath,
    required this.isMatched,
  });

  @override
  Widget build(BuildContext context) {
    if (isMatched) {
      return const SizedBox(height: 80);
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Draggable<String>(
        data: imagePath,
        feedback: Image.asset(imagePath, width: 80, height: 80),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: Image.asset(imagePath, width: 80, height: 80),
        ),
        child: Image.asset(imagePath, width: 80, height: 80),
      ),
    );
  }
}
