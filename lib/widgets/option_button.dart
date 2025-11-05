import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final String option;
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;
  final Color selectedColor;

  const OptionButton({
    Key? key,
    required this.option,
    required this.text,
    required this.isSelected,
    required this.onPressed,
    this.selectedColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? selectedColor : Colors.grey.shade300,
          padding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '$option. $text',
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}