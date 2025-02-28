import 'dart:io';

import 'package:budgeting_app/widgets/small_circular_button.dart';
import 'package:flutter/material.dart';

import '../utils/image_picker_utils.dart';

class ExpandableAttachmentButton extends StatefulWidget {
  const ExpandableAttachmentButton({
    super.key,
    required this.onImagesSelected,
    required this.onCameraImageSelected,
    required this.disabled,
  });

  final bool disabled;
  final void Function(List<File> images) onImagesSelected;
  final void Function(File image) onCameraImageSelected;

  @override
  State<ExpandableAttachmentButton> createState() =>
      _ExpandableAttachmentButtonState();
}

class _ExpandableAttachmentButtonState
    extends State<ExpandableAttachmentButton> {
  bool _isExpanded = false;
  static const double offset = 48;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          bottom: _isExpanded ? offset : 0,
          child: SmallCircularButton(
            onTap: (context) async {
              final imagesSelected = await ImagePickerUtils.pickImages();
              if (imagesSelected.isNotEmpty) {
                widget.onImagesSelected(imagesSelected);
              }
              _toggleExpand();
            },
            icon: const Icon(Icons.image_rounded),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          right: _isExpanded ? offset : 0,
          child: SmallCircularButton(
            onTap: (context) async {
              final imageSelected =
                  await ImagePickerUtils.pickImageFromCamera();
              if (imageSelected != null) {
                widget.onCameraImageSelected(imageSelected);
              }
              _toggleExpand();
            },
            icon: const Icon(Icons.camera_alt_rounded),
          ),
        ),

        SmallCircularButton(
          disabled: widget.disabled,
          onTap: (context) => _toggleExpand(),
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            child: Icon(
              key: ValueKey(_isExpanded),
              _isExpanded ? Icons.remove_outlined : Icons.add_rounded,
            ),
          ),
        ),
      ],
    );
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}
