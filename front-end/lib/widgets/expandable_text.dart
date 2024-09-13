import 'package:flutter/material.dart';
import 'package:food_buddy_frontend/utils/colors.dart';
import 'package:food_buddy_frontend/utils/dimentions.dart';
import 'package:food_buddy_frontend/widgets/small_text.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  const ExpandableText({super.key, required this.text});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  late String firstHalf;
  late String secondHalf;

  bool hiddenText = true;

  double textHeight = 200 * Dimentions.hUnit;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > textHeight) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf =
          widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      print(firstHalf);
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = SmallText(
        text: firstHalf,
        // height: 1.8 * Dimentions.hUnit,
        height: 1.5,
        size: 18 * Dimentions.hUnit,
        color: AppColors.darkGreyColor);

    if (secondHalf.isNotEmpty) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          // TEXT
          SmallText(
            text: hiddenText ? (firstHalf + '...') : (firstHalf + secondHalf),
            height: 1.8 * Dimentions.hUnit,
            size: 18 * Dimentions.hUnit,
            color: AppColors.darkGreyColor,
          ),
          //
          // BUTTON
          InkWell(
            onTap: () {
              setState(() {
                hiddenText = !hiddenText;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmallText(
                  text: hiddenText ? 'Show more' : 'Show less',
                  color: AppColors.lightBlueColor,
                  size: 16 * Dimentions.hUnit,
                ),
                Icon(
                  hiddenText
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: AppColors.lightBlueColor,
                )
              ],
            ),
          )
        ],
      );
    }

    return content;
  }
}
