import '../../../ui_utils/app_colors.dart';
import '../../../ui_utils/text_styles.dart';
import 'package:flutter/material.dart';

class DiabetesScoreItem extends StatelessWidget {
  final String titleText;
  final String optionTextOne;
  final String optionTextTwo;
  final String optionTextThree;
  final String optionTextFour;
  final int optionValueOne;
  final int optionValueTwo;
  final int optionValueThree;
  final int optionValueFour;
  final int groupValue;
  final Function onChanged;

  DiabetesScoreItem({
    this.titleText,
    this.optionTextOne,
    this.optionTextTwo,
    this.optionTextThree,
    this.optionTextFour,
    this.optionValueOne,
    this.optionValueTwo,
    this.optionValueThree,
    this.optionValueFour,
    this.groupValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                titleText,
                style: TextStyles.textStyle19,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Radio(
                    value: optionValueOne,
                    groupValue: groupValue,
                    onChanged: onChanged,
                  ),
                  Flexible(
                    child: Text(
                      optionTextOne,
                      style: TextStyles.mlDynamicTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Radio(
                    value: optionValueTwo,
                    groupValue: groupValue,
                    onChanged: onChanged,
                  ),
                  Flexible(
                    child: Text(
                      optionTextTwo,
                      style: TextStyles.mlDynamicTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        optionValueThree != null
            ? Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Radio(
                          value: optionValueThree,
                          groupValue: groupValue,
                          onChanged: onChanged,
                        ),
                        Flexible(
                          child: Text(
                            optionTextThree,
                            style: TextStyles.mlDynamicTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Radio(
                          value: optionValueFour,
                          groupValue: groupValue,
                          onChanged: onChanged,
                        ),
                        Flexible(
                          child: Text(
                            optionTextFour,
                            style: TextStyles.mlDynamicTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : SizedBox.shrink(),
        Divider(
          color: AppColors.borderLine,
          thickness: 1.0,
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
