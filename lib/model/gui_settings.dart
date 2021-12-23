class GuiSettings {
  bool appUserPreferencesOverrideAllowed;
  String appMemberlyLogoUrl;
  String appMemberlyNetworkFallback;
  String textFontGfontUrl;
  String textFontfamily;
  String textFontcolorContent;
  double textFontsizeContent;
  List<dynamic> textFontsizeHeadings;
  String bodyBackgroundColor;
  String bodyCardBorderColor;
  String bodyCardBoxShadowColor;
  List<dynamic> bodyCardBoxShadowOffset;
  List<dynamic> bodyCardBoxShadowRadius;
  String bodyBackgroundComponentsDisabledColor;
  String bodyBackgroundComponentsDisabledAlpha;
  String bodyBackgroundComponentsDisabledFaFreestyle;
  String bottomDockBorderColor;
  String bottomDockLeastGradientColor;
  int loadingSpinnerId;
  String appColorscheme;
  AppColorschemeDefinition appColorschemeDefinition;
  bool modernizedHome;
  bool logoOnHome;
  bool logoOnMenuGrid;
  bool logoTextRequired;
  bool menuGridAsInappwv;
  int menuGridLauncherIconId;
  String iconsFaFreestyle;
  bool iconsFaDuotoneEnabled;
  String iconsFaDuotonePrimaryColor;
  String iconsFaDuotoneSecondaryColor;
  double iconsFaDuotonePrimaryOpacity;
  double iconsFaDuotoneSecondaryOpacity;
  String httpInappwv404Path;
  String httpInappwv500Path;
  String appPrimaryColor;
  String appAccentColor;

  GuiSettings(
      {this.appUserPreferencesOverrideAllowed,
        this.appMemberlyLogoUrl,
        this.appMemberlyNetworkFallback,
        this.textFontGfontUrl,
        this.textFontfamily,
        this.textFontcolorContent,
        this.textFontsizeContent,
        this.textFontsizeHeadings,
        this.bodyBackgroundColor,
        this.bodyCardBorderColor,
        this.bodyCardBoxShadowColor,
        this.bodyCardBoxShadowOffset,
        this.bodyCardBoxShadowRadius,
        this.bodyBackgroundComponentsDisabledColor,
        this.bodyBackgroundComponentsDisabledAlpha,
        this.bodyBackgroundComponentsDisabledFaFreestyle,
        this.bottomDockBorderColor,
        this.bottomDockLeastGradientColor,
        this.loadingSpinnerId,
        this.appColorscheme,
        this.appColorschemeDefinition,
        this.modernizedHome,
        this.logoOnHome,
        this.logoOnMenuGrid,
        this.logoTextRequired,
        this.menuGridAsInappwv,
        this.menuGridLauncherIconId,
        this.iconsFaFreestyle,
        this.iconsFaDuotoneEnabled,
        this.iconsFaDuotonePrimaryColor,
        this.iconsFaDuotoneSecondaryColor,
        this.iconsFaDuotonePrimaryOpacity,
        this.iconsFaDuotoneSecondaryOpacity,
        this.httpInappwv404Path,
        this.httpInappwv500Path,
        this.appAccentColor,
        this.appPrimaryColor});

  GuiSettings.fromJson(Map<String, dynamic> json) {
    appUserPreferencesOverrideAllowed =
    json['app_user_preferences_override_allowed'];
    appMemberlyLogoUrl = json['app_memberly_logo_url'];
    appMemberlyNetworkFallback = json['app_memberly_network_fallback'];
    textFontGfontUrl = json['text_font_gfont_url'];
    textFontfamily = json['text_fontfamily'];
    textFontcolorContent = json['text_fontcolor_content'];
    textFontsizeContent = json['text_fontsize_content'];
    textFontsizeHeadings = json['text_fontsize_headings'];
    bodyBackgroundColor = json['body_background_color'];
    bodyCardBorderColor = json['body_card_border_color'];
    bodyCardBoxShadowColor = json['body_card_box_shadow_color'];
    bodyCardBoxShadowOffset = json['body_card_box_shadow_offset'];
    bodyCardBoxShadowRadius = json['body_card_box_shadow_radius'];
    bodyBackgroundComponentsDisabledColor =
    json['body_background_components_disabled_color'];
    bodyBackgroundComponentsDisabledAlpha =
    json['body_background_components_disabled_alpha'];
    bodyBackgroundComponentsDisabledFaFreestyle =
    json['body_background_components_disabled_fa_freestyle'];
    bottomDockBorderColor = json['bottom_dock_border_color'];
    bottomDockLeastGradientColor = json['bottom_dock_least_gradient_color'];
    loadingSpinnerId = json['loading_spinner_id'];
    appColorscheme = json['app_colorscheme'];
    appColorschemeDefinition = json['app_colorscheme_definition'] != null
        ? new AppColorschemeDefinition.fromJson(
        json['app_colorscheme_definition'])
        : null;
    modernizedHome = json['modernized_home'];
    logoOnHome = json['logo_on_home'];
    logoOnMenuGrid = json['logo_on_menu_grid'];
    logoTextRequired = json['logo_text_required'];
    menuGridAsInappwv = json['menu_grid_as_inappwv'];
    menuGridLauncherIconId = json['menu_grid_launcher_icon_id'];
    iconsFaFreestyle = json['icons_fa_freestyle'];
    iconsFaDuotoneEnabled = json['icons_fa_duotone_enabled'];
    iconsFaDuotonePrimaryColor = json['icons_fa_duotone_primary_color'];
    iconsFaDuotoneSecondaryColor = json['icons_fa_duotone_secondary_color'];
    iconsFaDuotonePrimaryOpacity = json['icons_fa_duotone_primary_opacity'];
    iconsFaDuotoneSecondaryOpacity = json['icons_fa_duotone_secondary_opacity'];
    httpInappwv404Path = json['http_inappwv_404_path'];
    httpInappwv500Path = json['http_inappwv_500_path'];
    appAccentColor = json['app_accent_color'];
    appPrimaryColor = json['app_primary_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_user_preferences_override_allowed'] =
        this.appUserPreferencesOverrideAllowed;
    data['app_memberly_logo_url'] = this.appMemberlyLogoUrl;
    data['app_memberly_network_fallback'] = this.appMemberlyNetworkFallback;
    data['text_font_gfont_url'] = this.textFontGfontUrl;
    data['text_fontfamily'] = this.textFontfamily;
    data['text_fontcolor_content'] = this.textFontcolorContent;
    data['text_fontsize_content'] = this.textFontsizeContent;
    data['text_fontsize_headings'] = this.textFontsizeHeadings;
    data['body_background_color'] = this.bodyBackgroundColor;
    data['body_card_border_color'] = this.bodyCardBorderColor;
    data['body_card_box_shadow_color'] = this.bodyCardBoxShadowColor;
    data['body_card_box_shadow_offset'] = this.bodyCardBoxShadowOffset;
    data['body_card_box_shadow_radius'] = this.bodyCardBoxShadowRadius;
    data['body_background_components_disabled_color'] =
        this.bodyBackgroundComponentsDisabledColor;
    data['body_background_components_disabled_alpha'] =
        this.bodyBackgroundComponentsDisabledAlpha;
    data['body_background_components_disabled_fa_freestyle'] =
        this.bodyBackgroundComponentsDisabledFaFreestyle;
    data['bottom_dock_border_color'] = this.bottomDockBorderColor;
    data['bottom_dock_least_gradient_color'] =
        this.bottomDockLeastGradientColor;
    data['loading_spinner_id'] = this.loadingSpinnerId;
    data['app_colorscheme'] = this.appColorscheme;
    if (this.appColorschemeDefinition != null) {
      data['app_colorscheme_definition'] =
          this.appColorschemeDefinition.toJson();
    }
    data['modernized_home'] = this.modernizedHome;
    data['logo_on_home'] = this.logoOnHome;
    data['logo_on_menu_grid'] = this.logoOnMenuGrid;
    data['logo_text_required'] = this.logoTextRequired;
    data['menu_grid_as_inappwv'] = this.menuGridAsInappwv;
    data['menu_grid_launcher_icon_id'] = this.menuGridLauncherIconId;
    data['icons_fa_freestyle'] = this.iconsFaFreestyle;
    data['icons_fa_duotone_enabled'] = this.iconsFaDuotoneEnabled;
    data['icons_fa_duotone_primary_color'] = this.iconsFaDuotonePrimaryColor;
    data['icons_fa_duotone_secondary_color'] =
        this.iconsFaDuotoneSecondaryColor;
    data['icons_fa_duotone_primary_opacity'] =
        this.iconsFaDuotonePrimaryOpacity;
    data['icons_fa_duotone_secondary_opacity'] =
        this.iconsFaDuotoneSecondaryOpacity;
    data['http_inappwv_404_path'] = this.httpInappwv404Path;
    data['http_inappwv_500_path'] = this.httpInappwv500Path;
    data['app_accent_color'] = this.appAccentColor;
    data['app_primary_color'] = this.appPrimaryColor;
    return data;
  }
}

class AppColorschemeDefinition {
  bool appBarGradientRequired;
  String appBarGradientDirection;
  String appBarGradientStartColor;
  String appBarGradientEndColor;
  List<double> appBarGradientStops;
  bool appBarBoxShadowRequired;
  String appBarBoxShadowColor;
  String appBarLoadingGraphics;

  AppColorschemeDefinition(
      {this.appBarGradientRequired,
        this.appBarGradientDirection,
        this.appBarGradientStartColor,
        this.appBarGradientEndColor,
        this.appBarGradientStops,
        this.appBarBoxShadowRequired,
        this.appBarBoxShadowColor,
        this.appBarLoadingGraphics});

  AppColorschemeDefinition.fromJson(Map<String, dynamic> json) {
    appBarGradientRequired = json['app_bar_gradient_required'];
    appBarGradientDirection = json['app_bar_gradient_direction'];
    appBarGradientStartColor = json['app_bar_gradient_start_color'];
    appBarGradientEndColor = json['app_bar_gradient_end_color'];
    appBarGradientStops = json['app_bar_gradient_stops'].cast<double>();
    appBarBoxShadowRequired = json['app_bar_box_shadow_required'];
    appBarBoxShadowColor = json['app_bar_box_shadow_color'];
    appBarLoadingGraphics = json['app_bar_loading_graphics'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_bar_gradient_required'] = this.appBarGradientRequired;
    data['app_bar_gradient_direction'] = this.appBarGradientDirection;
    data['app_bar_gradient_start_color'] = this.appBarGradientStartColor;
    data['app_bar_gradient_end_color'] = this.appBarGradientEndColor;
    data['app_bar_gradient_stops'] = this.appBarGradientStops;
    data['app_bar_box_shadow_required'] = this.appBarBoxShadowRequired;
    data['app_bar_box_shadow_color'] = this.appBarBoxShadowColor;
    data['app_bar_loading_graphics'] = this.appBarLoadingGraphics;
    return data;
  }
}
