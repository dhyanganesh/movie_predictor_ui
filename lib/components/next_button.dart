import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool enabled;

  const NextButton({
    Key? key,
    required this.onPressed,
    this.text = 'Next',
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey.shade400;
              }
              return Colors.amberAccent;
            }),
            foregroundColor: MaterialStateProperty.all(Colors.black),
          ),
          onPressed: enabled ? onPressed : null,
          child: Text(text),
        ),
      ),
    );
  }
}
