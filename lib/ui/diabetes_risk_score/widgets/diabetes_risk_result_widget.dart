import '../../../ui_utils/app_colors.dart';
import '../../../ui_utils/text_styles.dart';
import 'package:flutter/material.dart';

class DiabetesRiskResultWidget extends StatelessWidget {
  final String riskTitle;
  final String riskResult;
  final bool isChangeTextColor;

  DiabetesRiskResultWidget({
    this.riskTitle,
    this.riskResult,
    this.isChangeTextColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        Divider(
          color: AppColors.borderLine,
          thickness: 1.0,
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                riskTitle,
                style: isChangeTextColor
                    ? TextStyles.textStyle20
                    : TextStyles.textStyle19,
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Text(
                riskResult,
                style: isChangeTextColor
                    ? TextStyles.mlDynamicTextStyleWithColor
                    : TextStyles.mlDynamicTextStyle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
