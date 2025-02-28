import 'package:budgeting_app/extensions.dart';
import 'package:budgeting_app/screens/chat_screen/state/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class InputSection extends StatefulWidget {
  const InputSection({super.key});

  @override
  State<InputSection> createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  final TextEditingController _controller = TextEditingController();

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
                    if (hasSelectedContent)
                      Row(
                        spacing: 8.0,
                        children: [
                          if (expenses.isNotEmpty)
                            _buildInfoTile(
                              context: context,
                              icon: Icons.receipt_long,
                              count: expenses.length,
                              heroTag: 'expenses',
                            ),
                        ],
                      ),
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
                    SendMessageButton(controller: _controller),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoTile({
    required BuildContext context,
    required IconData icon,
    required int count,
    required String heroTag,
  }) {
    return Container(
      padding: EdgeInsets.all(4.0),
      decoration: ShapeDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        shape: StadiumBorder(),
      ),
      child: Row(
        spacing: 4.0,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: context.colorScheme.secondary,
            child: Icon(icon, size: 18, color: context.colorScheme.onSecondary),
          ),
          Text(
            count.toString(),
            style: context.textTheme.labelLarge?.copyWith(
              color: context.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class SendMessageButton extends StatelessWidget {
  final TextEditingController controller;
  const SendMessageButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: CircleBorder(),
      color: context.colorScheme.secondary,
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: () => sendMessage(context),
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: SvgPicture.asset(
            'assets/send.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              context.colorScheme.onSecondary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  void sendMessage(BuildContext context) async {
    final message = controller.text;

    final viewModel = context.read<ChatViewModel>();

    final expenses = viewModel.state.selectedExpenses;

    final contextText = '''
      Selected expenses: [${expenses.map((e) => e.toMap()).join(', ')}],
    ''';

    viewModel.sendMessage(message, contextText);

    controller.clear();
  }
}
