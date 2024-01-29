// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:education_app/core/res/my_colors.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.sectionTitle,
    required this.seeAll,
    required this.onSeeAll,
    super.key,
  });

  final String sectionTitle;
  final bool seeAll;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          sectionTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (seeAll)
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              splashFactory: NoSplash.splashFactory,
            ),
            child: const Text(
              'See All',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: MyColors.primaryColour,
              ),
            ),
          ),
      ],
    );
  }
}
