import '../login/colors/color_info.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class TextStyles {
  TextStyles._();

  static final textStyleAppBar = TextStyle(
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontSize: 15.0);

  static const headerTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w700);

  static const textStyle2 = TextStyle(
      color: Colors.black, fontWeight: FontWeight.w700, fontSize: 34.0);

  static const textStyle4 = TextStyle(
      color: Colors.black, fontWeight: FontWeight.w800, fontSize: 15.0);

  static const rewardProductPriceAfterMinStyle = TextStyle(
      color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16.0);

  static const textStyle7 = TextStyle(
      color: Colors.black, fontWeight: FontWeight.w800, fontSize: 15.0);

  static const textStyle3 =
      TextStyle(color: AppColors.greyishBrown, fontSize: 15.0);

  static const textStyle = TextStyle(
      color: Colors.black, fontWeight: FontWeight.w800, fontSize: 14.0);

  static const smallButtonTextStyle = TextStyle(
      color: Colors.black, fontWeight: FontWeight.w800, fontSize: 12.0);

  static const textStyle6 = TextStyle(
      color: AppColors.lightGrey, fontWeight: FontWeight.w800, fontSize: 14.0);

  static final textStyle5 =
      TextStyle(color: AppColors.lightGrey, fontSize: 12.0);

  static final textStyle13 =
      TextStyle(color: AppColors.primaryColor, fontSize: 18.0);
  static final textStyle14 =
      TextStyle(color: Colors.greenAccent, fontSize: 15.0);
  static final textStyle16 =
      TextStyle(color: AppColors.lightGrey, fontSize: 12);
  static final textStyle17 = TextStyle(
      color: AppColors.lightGrey, fontSize: 14, fontWeight: FontWeight.w800);
  static final textStyle15 = TextStyle(
      color: Colors.greenAccent, fontWeight: FontWeight.w800, fontSize: 17.0);

  static const textStyle8 =
      TextStyle(color: AppColors.lightGrey, fontSize: 12.0);

  static const textStyle9 =
      TextStyle(color: AppColors.lightGrey, fontSize: 15.0);

  static const textStyle10 =
      TextStyle(color: AppColors.greyishBrown, fontSize: 13.0);

  static const commentTimeMinStyle =
      TextStyle(color: AppColors.greyishBrown, fontSize: 10.0);

  static const textStyle11 = TextStyle(
      color: AppColors.greyishBrown,
      fontWeight: FontWeight.w800,
      fontSize: 13.0);

  static const textStyleUnderline = TextStyle(
    color: AppColors.greyishBrown,
    fontSize: 13.0,
    decoration: TextDecoration.underline,
  );

  static const textStyle12 = TextStyle(
      color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14.0);
  static const tamilStyleCheckIn = TextStyle(fontSize: 10.0);
  static const tamilStyle = TextStyle(fontSize: 13.0);
  static const tamilStyleBold = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.bold,
  );
  static final mlDynamicTextStyle = AppPreferences().isLanguageTamil()
      ? TextStyles.tamilStyle
      : TextStyle(fontSize: 15);

  static final mlDynamicTextStyleWithColor = AppPreferences().isLanguageTamil()
      ? TextStyles.tamilStyle
      : TextStyle(fontSize: 16, color: AppColors.arrivedColor);

  static final grayedOutTextStyle =
      TextStyle(color: AppColors.warmGrey, fontSize: 16);

  static final blackOutTextStyle = TextStyle(color: Colors.black, fontSize: 16);

  static final textStyle18 = TextStyle(
      color: Colors.deepOrangeAccent,
      fontSize: 17,
      fontWeight: FontWeight.w600);

  static const textStyle19 = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );

  static const textStyle20 = TextStyle(
      color: AppColors.arrivedColor,
      fontWeight: FontWeight.w600,
      fontSize: 15.0);

  static const TextStyle countryCodeStyle = TextStyle(
    fontFamily: Constants.LatoRegular,
    color: Colors.grey,
    fontSize: 15.0,
  );
  static const TextStyle countryInitSpinnerStyle = TextStyle(
    fontFamily: Constants.LatoRegular,
    color: Colors.black38,
    fontSize: 15.0,
  );

  static const TextStyle textStyle100 = TextStyle(
      fontFamily: Constants.LatoRegular,
      fontSize: 15.0,
      color: Color(ColorInfo.BLACK));
/*
  static final textStyle18 = TextStyle(
      color: Colors.white,  fontSize: 25.0);*/
}
