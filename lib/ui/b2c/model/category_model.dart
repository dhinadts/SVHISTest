import 'base_response.dart';

class ProfileCategoryModel extends BaseResponse {
  String categoryType;
  String subCategoryType;

  ProfileCategoryModel({
    this.categoryType,
    this.subCategoryType,
  });

  ProfileCategoryModel.fromJson(Map<String, dynamic> json) {
    categoryType = json['category_type'];
    subCategoryType = json['subcategory_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['category_type'] = this.categoryType;
    data['subcategory_type'] = this.subCategoryType;

    //print("Hello Pranay ,profile update of new user $data");

    return data;
  }
}
