import 'dart:io';

import 'package:budgeting_app/extensions.dart';
import 'package:budgeting_app/screens/chat_screen/components/picked_image_renderer.dart';
import 'package:budgeting_app/states/chat/chat_view_model.dart';
import 'package:budgeting_app/utils/image_picker_utils.dart';
import 'package:budgeting_app/widgets/expenses_count_label.dart';
import 'package:budgeting_app/widgets/small_circular_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class InputSection extends StatefulWidget {
  const InputSection({super.key});

  @override
  State<InputSection> createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  final TextEditingController _controller = TextEditingController();
  List<File> _images = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatViewModel, ChatState>(
      builder: (context, state) {
        final expenses = state.selectedExpenses;

        final bool hasSelectedContent = expenses.isNotEmpty;
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.surface,
                blurRadius: 12,
                spreadRadius: 4,
                offset: Offset(0, -12),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.all(8.0) +
                  EdgeInsets.only(
                    bottom: MediaQuery.viewInsetsOf(context).bottom,
                  ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: context.colorScheme.surfaceContainer,
                    width: 2,
                  ),
                ),
                child: Column(
                  spacing: 2,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _controller,
                      minLines: 3,
                      maxLines: 3,
                      textInputAction: TextInputAction.done,
                      style: context.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Ask me anything...',
                        hintStyle: context.textTheme.bodyMedium,
                        // No borders
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                    // new code
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (hasSelectedContent)
                          ExpensesCountLabel(count: expenses.length),

                        _images.isNotEmpty
                            ? Wrap(
                              spacing: 12.0,
                              children:
                                  _images
                                      .map(
                                        (e) => Animate(
                                          effects: [
                                            FadeEffect(duration: 0.5.seconds),
                                            ShakeEffect(
                                              hz: 4,
                                              delay: 0.5.seconds,
                                              duration: 0.5.seconds,
                                            ),
                                          ],
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              PickedImageRenderer(image: e),
                                              Positioned(
                                                top: -8,
                                                right: -8,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _images.remove(e);
                                                    });
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        context
                                                            .colorScheme
                                                            .secondaryContainer,
                                                    radius: 12,
                                                    child: Icon(
                                                      size: 16,
                                                      Icons.close,
                                                      color:
                                                          context
                                                              .colorScheme
                                                              .onSecondaryContainer,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                            )
                            : SizedBox(),

                        Spacer(),
                        SmallCircularButton(
                          disabled: _images.length == 3,
                          onTap: (context) {
                            showModalBottomSheet(
                              context: context,
                              showDragHandle: true,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.camera_alt),
                                      title: Text('Camera'),
                                      onTap: () async {
                                        final image =
                                            await ImagePickerUtils.pickImageFromCamera();
                                        if (image != null) {
                                          setState(() {
                                            _images.add(image);
                                          });
                                        }
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.photo),
                                      title: Text('Gallery'),
                                      onTap: () async {
                                        final images =
                                            await ImagePickerUtils.pickImages();
                                        if (images.isNotEmpty) {
                                          if (images.length > 3) {
                                            setState(() {
                                              _images = images.sublist(0, 3);
                                            });
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text('Warning'),
                                                  content: Text(
                                                    'You can only select up to 3 images.',
                                                  ),
                                                );
                                              },
                                            );
                                          } else {
                                            setState(() {
                                              while (_images.length < 3) {
                                                _images.add(images.removeAt(0));
                                              }
                                            });
                                          }
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.add_rounded),
                        ),
                        SizedBox(width: 8),
                        SendMessageButton(
                          controller: _controller,
                          images: _images,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SendMessageButton extends StatelessWidget {
  final TextEditingController controller;
  final List<File>? images;
  const SendMessageButton({super.key, required this.controller, this.images});

  @override
  Widget build(BuildContext context) {
    return SmallCircularButton(
      onTap: sendMessage,
      icon: SvgPicture.asset('assets/send.svg'),
    );
  }

  void sendMessage(BuildContext context) async {
    final message = controller.text;

    final viewModel = context.read<ChatViewModel>();

    final expenses = viewModel.state.selectedExpenses;

    final contextText = '''
      Selected expenses: [${expenses.map((e) => e.toMap()).join(', ')}],
    ''';

    viewModel.sendMessage(
      message: message,
      queryContext: contextText,
      images: images,
    );

    controller.clear();
  }
}
