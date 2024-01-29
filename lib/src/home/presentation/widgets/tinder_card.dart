import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class TinderCard extends StatelessWidget {
  const TinderCard({
    required this.isFirst,
    super.key,
    this.color,
  });

  final bool isFirst;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: isFirst ? const EdgeInsets.only(top: 65) : null,
        color: isFirst ? Colors.red : null,
        child: Center(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                height: 137,
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  gradient: isFirst
                      ? const LinearGradient(
                          colors: [Color(0xFF8E96FF), Color(0xFFA06AF9)],
                        )
                      : null,
                  color: color,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.15),
                      offset: const Offset(0, 5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: isFirst
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '${context.courseOfTheDay?.title ?? 'Chemistry'}'
                            ' final\nexams',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          const Row(
                            children: [
                              Icon(
                                IconlyLight.notification,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '45 minutes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : null,
              ),
              if (isFirst)
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Image.asset(
                    MediaRes.microscope,
                    height: 100,
                    width: 149,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}