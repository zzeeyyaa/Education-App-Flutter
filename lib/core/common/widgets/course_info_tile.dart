// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:education_app/core/res/my_colors.dart';
import 'package:flutter/material.dart';

class CourseInfoTile extends StatelessWidget {
  const CourseInfoTile({
    required this.image,
    required this.title,
    required this.subtitle,
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;
  final String image;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
            height: 48,
            width: 48,
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Transform.scale(
                scale: 1.45,
                child: Image.asset(image),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: MyColors.neutralTextColour,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
