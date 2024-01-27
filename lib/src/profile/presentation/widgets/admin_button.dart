// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:education_app/core/res/my_colors.dart';
import 'package:flutter/material.dart';

class AdminButton extends StatelessWidget {
  const AdminButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      label: Text(label),
      icon: Icon(icon),
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.primaryColour,
        foregroundColor: Colors.white,
      ),
    );
  }
}
