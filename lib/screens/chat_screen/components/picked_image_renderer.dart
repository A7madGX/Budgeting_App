import 'dart:io';

import 'package:flutter/material.dart';

class PickedImageRenderer extends StatelessWidget {
  const PickedImageRenderer({super.key, required this.image});

  final File image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(image, width: 32, height: 32, fit: BoxFit.cover),
    );
  }
}
