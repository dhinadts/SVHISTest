import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const _primaryColorDefault =
      const Color(0xff000080); // const Color(0xFF1E8449);
  static Color _primaryColor;

  static Color get primaryColor {
    return _primaryColor ?? _primaryColorDefault;
  }

  static set primaryColor(Color color) => _primaryColor = color;
  static const defaultPrimaryColor = const Color(0xFF1E8449);
  static const dattPrimaryColor = const Color(0xFF1E8449);
  static const primaryColorDark = const Color(0xff000080);
  static const backupPrimaryColor = const Color(0xFF77A9F7);
  static const primaryLightColor = Color(0xff5fc7ff);
  static const accentColor = Color(0xff9b9b9b);
  static const indentedLightColor = Color(0x1A737373);
  static const assignedLightColor = Color(0x1AE48F00);
  static const deliveredColor = Color(0xFF17A500);
  static const arrivedLightColor = Color(0x1A3F6ABF);
  static const dispatchedLightColor = Color(0x1A50A6E3);
  static const deliveredLightColor = Color(0x1A57994E);
  static const indentedColor = Color(0xFF737373);
  static const assignedColor = Color(0xFFE48F00);
  static const arrivedColor = Color(0xFF3F6ABF);
  static const dispatchedColor = Color(0xFF50A6E3);
  static const cancelLightColor = Color(0xffcaae);
  static const borderShadow = Color(0xFFEEEEEE);
  static const transparentBg = Color(0x9C000000);
  static const borderLine = Color(0xFFAAAAAA);

  static const greyishBrown = Color(0xff4a4a4a); // 18 textStyles
  static const lightGrey = Color(0xffd8d8d8); // 8 textStyles
  static const warmGrey = Color(0xff9b9b9b); // 7 textStyles
  static const paleGrey = Color(0xfff4f6f8);

  static const facebookBtn = Color(0xff3b5998); //denimBlue;
  static const dividerColor = Color(0xffd8d8d8); //lightGrey;
  static const starFill = Color(0xffe6cb8d); //sand
  static const starBorder = Color(0xffd8d8d8); //lightGrey
  static const searchFieldIcons = Color(0xffd8d8d8); //lightGrey
  static final boxShadow = Color(0xff9b9b9b).withOpacity(0.2); //warmGrey
  static const unselectedTabLabel = Color(0xffd8d8d8);
  static const unselectedBottomNavigation = Color(0xff9b9b9b);
  static const alertDialogBg = Color(0xff93C8E9);

  static const lightTeal = Color(0xff8fcae7); // 2 icons background

  static const goldenYellow = Color(0xfffeca14);
  static const hyperlinkColor = Color(0xff007aff);
  static const Color rosa = Color(0xfffc8d9d);

  // Notification icons
  static const notificationProfile = Color(0xff007ac9); //cerulean
  static const notificationBookmark = Color(0xff00257a); //marineBlue
  static const notificationCoupon = Color(0xff3b5998); //denimBlue
  static const notificationProduct = Color(0xffd8d8d8); //lightGrey
  static const notificationWallet = Color(0xffe6cb8d); //sand

  // Help center icons
  static const helpEmailUs = Color(0xff007ac9); //cerulean
  static const helpFAQ = Color(0xff00257a); //marineBlue
  static const helpCallUs = Color(0xff8fcae7); //lightTeal

  // Coupons
  static const couponGradientStart = Color(0xffe6cb8d); //sand
  static const couponGradientEnd = Color(0xffdda11d);
  static const verifiedUserIcon = Color(0xff88d633);
  static const darkGrassGreen = Color(0xff398601);

  // Belly Badges
  static const bellyBadgeEmptyItemBackground = Color(0xff8fcae7); //lightTeal

  // sand gradient colors
  static const sandGradient1 = Color(0xffab8a5c);
  static const sandGradient2 = Color(0xffd4b474);
  static const sandGradient3 = Color(0xffd6b676);
  static const sandGradient4 = Color(0xffba9766);

  static const rewardsOverview = Color(0xfffde285);
  static const scannerPageIconBackground = Color(0xffc99f5a); // camel
  static const lightMutedYellow = Color(0xfffeec88);
  static const lightWashedYellow = Color(0xfffcd450);
  static const mummyLevelTierStepper = Color(0xffc99f5a);
  static const mummyLevelTabBodyColor = Color(0xfff6f6f6);
  static const location = Color(0xff484848);

  static const darkGold = Color(0xffcca519);
  static const babyPoop = Color(0xff927600);
  static const mudBrown = Color(0xff4b3f0c);
  static const camouflageGreen87 = Color(0xff455711);
  static const brick = Color(0xffcd2424);
  static const offWhite = Color(0xfff7f6f2);
  static const trackerItemBodyColor = Color(0xfff6f6f6);

  static const warmPink = Color(0xfffe4e70);

  static const tabBarIndicatorColor = Colors.white;
  static final Color kImageBackgroundColor = Color(0xfff7f9fe);
  static final Color kImageBorderColor = Colors.grey.shade500;
  static final Color kHintTextColor = Color(0xff54585a);
  static final Color kMainTextColor = Color(0xff333333);
  static final Color kChatMeColor = Color(0xfff0f8ff);
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
