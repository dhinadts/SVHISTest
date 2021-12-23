class EnvProps {
  String colorScheme; // ToDo
  String orgDisplayName;
  String clientId;
  String paymentGateway;
  String defaultCurrency;
  List<String> defaultPaymentOptions;
  bool membershipFeesRequired;
  String clientName;
  SdxEnvironmentMembershipFeesStructure membershipFeesStructure;
  String logoUrl;
  bool dailyCheckinEnabled;
  List<String> workflowStatus;
  bool profileHistoryEnabled;
  String membershipTermsAndConditions;
  String membershipBenefitsContent;
  String signUpTermsAndConditions;
  bool userDailyCheckInReportEnabled;
  List<String> supportingDocs;
  String supportingDocDeclarationText;
  String appId;
  String appToken;
  String get interstitialAdUnitId => clientId == "DATT"
      ? "ca-app-pub-6897851980656595/9163840313"
      : "ca-app-pub-6897851980656595/8242738369";

  String get bannerAdUnitId => clientId == "DATT"
      ? "ca-app-pub-6897851980656595/9921909288"
      : "ca-app-pub-6897851980656595/6960418610";
  String defaultCurrencySymbol;
  String defaultCurrencySuffix;

  EnvProps(
      {this.colorScheme,
      this.orgDisplayName,
      this.clientId,
      this.paymentGateway,
      this.defaultCurrency,
      this.defaultPaymentOptions,
      this.membershipFeesRequired,
      this.membershipFeesStructure,
      this.logoUrl,
      this.clientName,
      this.membershipTermsAndConditions,
      this.profileHistoryEnabled,
      this.membershipBenefitsContent,
      this.signUpTermsAndConditions,
      this.dailyCheckinEnabled,
      this.userDailyCheckInReportEnabled,
      this.supportingDocDeclarationText,
      this.supportingDocs,
      this.appId,
      this.appToken,
      this.workflowStatus,
      this.defaultCurrencySuffix,
      this.defaultCurrencySymbol});

  EnvProps.fromJson(Map<String, dynamic> json) {
    colorScheme = json['sdx.mobile.org.color.scheme'];
    orgDisplayName = json['sdx.mobile.org.display.name'];
    clientId = json['sdx.environment.client.id'];
    paymentGateway = json['sdx.environment.payment.gateway'];
    defaultCurrency = json['sdx.environment.default.currency'];
    clientName = json["sdx.mobile.org.display.name"];
    defaultPaymentOptions =
        json['sdx.environment.default.payment.options'].cast<String>();
    membershipFeesRequired = json['sdx.environment.membership.fees.required'];
    membershipFeesStructure =
        json['sdx.environment.membership.fees.structure'] != null
            ? new SdxEnvironmentMembershipFeesStructure.fromJson(
                json['sdx.environment.membership.fees.structure'])
            : null;
    logoUrl = json['sdx.mobile.org.logo.url'];
    workflowStatus =
        json['sdx.environment.membership.workflow.status'].cast<String>();
    dailyCheckinEnabled =
        json['com.sdx.mobile.user.dailycheckin.report.enabled'];
    profileHistoryEnabled =
        json['com.sdx.mobile.user.dailycheckin.report.enabled'];
    membershipTermsAndConditions =
        json['com.sdx.mobile.membership.termsandconditions'];
    membershipBenefitsContent =
        json['com.sdx.mobile.membership.benefits.content'];
    signUpTermsAndConditions = json['com.sdx.mobile.signup.termsandconditions'];
    userDailyCheckInReportEnabled =
        json['com.sdx.mobile.user.dailycheckin.enabled'];
    supportingDocs = json['com.sdx.mobile.donation.supportingdocs.urls'] != null
        ? json['com.sdx.mobile.donation.supportingdocs.urls'].cast<String>()
        : null;
    supportingDocDeclarationText =
        json['com.sdx.mobile.donation.supportingdocs.declarationtext'] != null
            ? json['com.sdx.mobile.donation.supportingdocs.declarationtext']
            : null;
    appId = json['com.sdx.environment.video.agora.appId'];
    appToken = json['com.sdx.environment.video.agora.token'];
    defaultCurrencySymbol = json['com.sdx.platform.default.currency.symbol'];
    defaultCurrencySuffix = json['com.sdx.platform.default.currency.suffix'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sdx.mobile.org.color.scheme'] = this.colorScheme;
    data['sdx.mobile.org.display.name'] = this.orgDisplayName;
    data['sdx.environment.client.id'] = this.clientId;
    data['sdx.environment.payment.gateway'] = this.paymentGateway;
    data['sdx.environment.default.currency'] = this.defaultCurrency;
    data['sdx.environment.default.payment.options'] =
        this.defaultPaymentOptions;
    data['sdx.environment.membership.fees.required'] =
        this.membershipFeesRequired;
    if (this.membershipFeesStructure != null) {
      data['sdx.environment.membership.fees.structure'] =
          this.membershipFeesStructure.toJson();
    }
    data['sdx.mobile.org.logo.url'] = this.logoUrl;
    data['sdx.environment.membership.workflow.status'] = this.workflowStatus;
    data['com.sdx.mobile.signup.termsandconditions'] =
        this.signUpTermsAndConditions;
    data['com.sdx.mobile.user.dailycheckin.report.enabled'] =
        this.dailyCheckinEnabled;
    data['com.sdx.mobile.user.profile.history.enabled'] =
        this.profileHistoryEnabled;
    data['com.sdx.mobile.membership.termsandconditions'] =
        this.membershipTermsAndConditions;
    data['com.sdx.mobile.user.dailycheckin.enabled'] =
        this.userDailyCheckInReportEnabled;
    data['com.sdx.mobile.donation.supportingdocs.urls'] = this.supportingDocs;
    data['com.sdx.mobile.donation.supportingdocs.declarationtext'] =
        this.supportingDocDeclarationText;
    data['com.sdx.environment.video.agora.appId'] = this.appId;
    data['com.sdx.environment.video.agora.token'] = this.appToken;
    data['com.sdx.platform.default.currency.symbol'] =
        this.defaultCurrencySymbol;
    data['com.sdx.platform.default.currency.suffix'] =
        this.defaultCurrencySuffix;

    return data;
  }
}

class SdxEnvironmentMembershipFeesStructure {
  String componentName;
  List<Child> child;

  SdxEnvironmentMembershipFeesStructure({this.componentName, this.child});

  SdxEnvironmentMembershipFeesStructure.fromJson(Map<String, dynamic> json) {
    componentName = json['componentName'];
    if (json['child'] != null) {
      child = new List<Child>();
      json['child'].forEach((v) {
        child.add(new Child.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['componentName'] = this.componentName;
    if (this.child != null) {
      data['child'] = this.child.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Child {
  String componentName;
  String componentValue;
  String componentDescription;
  List<Child> child;

  Child(
      {this.componentName,
      this.componentValue,
      this.componentDescription,
      this.child});

  Child.fromJson(Map<String, dynamic> json) {
    componentName = json['componentName'];
    componentValue = json['componentValue'];
    componentDescription = json['componentDescription'];
    if (json['child'] != null) {
      child = new List();
      json['child'].forEach((v) {
        child.add(Child.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['componentName'] = this.componentName;
    data['componentValue'] = this.componentValue;
    data['componentDescription'] = this.componentDescription;
    if (this.child != null) {
      data['child'] = this.child.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
