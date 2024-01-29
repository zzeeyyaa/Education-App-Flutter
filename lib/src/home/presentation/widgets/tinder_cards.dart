import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/src/home/presentation/widgets/tinder_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

class TinderCards extends StatefulWidget {
  const TinderCards({super.key});

  @override
  State<TinderCards> createState() => _TinderCardsState();
}

class _TinderCardsState extends State<TinderCards>
    with TickerProviderStateMixin {
  final CardController cardController = CardController();
  int totalCards = 10;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      height: context.widht,
      width: context.widht,
      child: TinderSwapCard(
        cardController: cardController,
        totalNum: totalCards,
        swipeEdge: context.widht,
        maxHeight: context.widht * .9,
        minWidth: context.widht * .71,
        minHeight: context.widht * .85,
        allowSwipe: false,
        swipeUpdateCallback: (DragUpdateDetails details, Alignment alignment) {
          //get card alignment
          if (alignment.x < 0) {
            //card is left swiping
          } else if (alignment.x > 0) {
            //card is right
          }
        },
        swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
          //if card is the last card, add more cards to be swipped
          if (index == totalCards - 1) {
            setState(() {
              totalCards += 10;
            });
          }
        },
        cardBuilder: (context, index) {
          final isFirst = index == 0;
          final colorByIndex =
              index == 1 ? const Color(0xFFD192FC) : const Color(0xFFDC95FB);
          return Stack(
            children: [
              Positioned(
                bottom: 110,
                right: 0,
                left: 0,
                child: TinderCard(
                  isFirst: isFirst,
                  color: isFirst ? null : colorByIndex,
                ),
              ),
            ],
          );
        },
      ),
    ));
  }
}
