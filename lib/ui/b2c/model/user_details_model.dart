import 'base_response.dart';

class UserDetailsModel extends BaseResponse {
  num id;
  String firstName;
  String middleName;
  String lastName;
  String organizationName;
  String jobTitle;
  String address1;
  String address2;
  String city;
  String zipCode;
  String state;
  String county;
  String mobile;
  bool toHide;
  String companyIndividual;
  String chamberBuying;
  String aboutUs;
  String revenueAffected;
  String forcedLayoff;
  num forcedLayoffNo;
  num contentType;
  num user;
  String categoryType;
  String subCategoryType;
  String attachProfileRequester;
  List<dynamic> categoryList;

  UserDetailsModel({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.organizationName,
    this.jobTitle,
    this.address1,
    this.address2,
    this.city,
    this.zipCode,
    this.state,
    this.county,
    this.mobile,
    this.toHide,
    this.companyIndividual,
    this.chamberBuying,
    this.aboutUs,
    this.revenueAffected,
    this.forcedLayoff,
    this.forcedLayoffNo,
    this.contentType,
    this.user,
    this.categoryType,
    this.subCategoryType,
    this.categoryList,
    this.attachProfileRequester,
  });

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstname'];
    middleName = json['middlename'];
    lastName = json['lastname'];
    organizationName = json['organization_name'];
    jobTitle = json['job_title'];
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    zipCode = json['zipcode'];
    state = json['state'];
    county = json['county'];
    mobile = json['mobile'];
    toHide = json['to_hide'];
    companyIndividual = json['company_individual'];
    chamberBuying = json['chamber_buying'];
    aboutUs = json['about_us'];
    revenueAffected = json['revenue_affected'];
    forcedLayoff = json['forced_layoff'];
    forcedLayoffNo = json['forced_layoff_no'];
    contentType = json['content_type'];
    user = json['user'];
    categoryList = json['category_list'];
    attachProfileRequester = json['attach_profile_requester'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['firstname'] = this.firstName;
    data['lastname'] = this.lastName;
    data['organization_name'] = this.organizationName;
    data['job_title'] = this.jobTitle;
    data['address1'] = this.address1;
    data['city'] = this.city;
    data['county'] = this.county;
    data['state'] = this.state;
    data['zipcode'] = this.zipCode;
    data['mobile'] = this.mobile;
    data['to_hide'] = this.toHide;
    data['company_individual'] = this.companyIndividual;
    data['chamber_buying'] = this.chamberBuying;
    data['revenue_affected'] = this.revenueAffected;
    data['forced_layoff'] = this.forcedLayoff;
    data['forced_layoff_no'] = this.forcedLayoffNo;
    data['about_us'] = this.aboutUs;
    //data['attach_profile_requester']= this.attachProfileRequester;
//    data['category_type'] = this.categoryType;
//    data['subcategory_type'] = this.subCategoryType;

    print("Hello Pranay ,profile update of new user $data");

    return data;
  }
}
