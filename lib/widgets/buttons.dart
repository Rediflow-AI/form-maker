import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SecondaryFlatButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const SecondaryFlatButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: primaryActiveColor),
        shape: RoundedRectangleBorder(borderRadius: primaryBorderRadius),
      ),
      child: child,
    );
  }
}

class TertiaryIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData iconData;

  const TertiaryIconButton({
    Key? key,
    required this.onPressed,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(iconData),
      style: IconButton.styleFrom(
        backgroundColor: onPressed != null
            ? primaryActiveColor.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        foregroundColor: onPressed != null ? primaryActiveColor : Colors.grey,
      ),
    );
  }
}

class TertiaryFlatButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const TertiaryFlatButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: primaryBorderRadius),
        backgroundColor: primaryActiveColor.withOpacity(0.1),
      ),
      child: child,
    );
  }
}
