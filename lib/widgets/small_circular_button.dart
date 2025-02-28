import 'package:budgeting_app/extensions.dart';
import 'package:flutter/material.dart';

class SmallCircularButton extends StatelessWidget {
  const SmallCircularButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.disabled = false,
  });

  final void Function(BuildContext context) onTap;
  final Widget icon;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: disabled ? 0.5 : 1,
      child: Material(
        shape: CircleBorder(),
        color: context.colorScheme.secondary,
        child: InkWell(
          customBorder: CircleBorder(),
          onTap: disabled ? null : () => onTap(context),
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                context.colorScheme.onSecondary,
                BlendMode.srcIn,
              ),
              child: SizedBox.square(dimension: 27, child: icon),
            ),
          ),
        ),
      ),
    );
  }
}
