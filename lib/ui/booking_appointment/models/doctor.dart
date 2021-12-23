/////***** */
///
///

class DoctorAvailabilityInfo {
  List<String> availableDays;

  DoctorAvailabilityInfo({
    this.availableDays,
  });

  DoctorAvailabilityInfo.fromJson(Map<String, dynamic> json) {
    availableDays = json["availableDays"] == null
        ? []
        : List<String>.from(json["availableDays"].map((x) => x));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['availableDays'] = this.availableDays ?? [];
    return data;
  }
}

class Doctor {
  bool active;
  // String address1;
  // String address2;
  // String businessPhone;
  // String city;
  // String comments;
  // String country;
  // String createdBy;
  // String createdOn;
  // String doctorDesc;
  String doctorId;
  String doctorName;
  String education;
  String doctorUserName;

  // String modifiedBy;
  // String modifiedOn;
  List<String> speciality;
  // List<String> availableDays;
  // String startedWorkingOn;
  // String state;
  // String status;
  // List<String> workingHours;
  // String zipcode;
  String image;
  String registrationNumber;
  int videoConsultationFee;
  double rating;
  String location;
  String firstname;
  String lastname;
  String downloadProfileURL;
bool isConsultant;
  Doctor(
      {this.active,
      // this.address1,
      // this.address2,
      // this.businessPhone,
      // this.city,
      // this.comments,
      // this.country,
      // this.createdBy,
      // this.createdOn,
      // this.availableDays,
      // this.doctorDesc,
      this.doctorId,
      this.doctorName,
      this.education,
      // this.modifiedBy,
      // this.modifiedOn,
      this.speciality,
      // this.startedWorkingOn,
      // this.state,
      // this.status,
      // this.workingHours,
      // this.zipcode,
      this.downloadProfileURL,
      this.image,
      this.registrationNumber,
      this.videoConsultationFee,
      this.rating,
      this.location,
      this.firstname,
      this.lastname,
      this.doctorUserName,
      this.isConsultant});

  Doctor.fromJson(Map<String, dynamic> json) {
    active = json['active'] ?? false;
    // address1 = json['address1'] ?? "";
    // address2 = json['address2'] ?? "";
    // businessPhone = json['businessPhone'] ?? "";
    // city = json['city'] ?? "";
    // comments = json['comments'] ?? "";
    // country = json['country'] ?? "";
    // createdBy = json['createdBy'] ?? "";
    // createdOn = json['createdOn'] ?? "";
    // doctorDesc = json['doctorDesc'] ?? "";
    doctorId = json['doctorId'] ?? "";
    doctorName = json['userFullName'] ?? "";
    education = json['education'] ?? "";
    downloadProfileURL = json['downloadProfileURL'] ?? "";
    // modifiedBy = json['modifiedBy'] ?? "";
    // modifiedOn = json['modifiedOn'] ?? "";
    speciality = json["specialities"] != null
        ? List<String>.from(json["specialities"].map((x) => x))
        : [];
    // startedWorkingOn = json['startedWorkingOn'] ?? "";
    // state = json['state'] ?? "";
    // status = json['status'] ?? "";
    // workingHours = json["workingHours"] != null
    //     ? List<String>.from(json["workingHours"].map((x) => x))
    //     : [];
    // zipcode = json['zipcode'] ?? "";
    // availableDays = json["availableDays"] != null
    //     ? List<String>.from(json["availableDays"].map((x) => x))
    //     : [];
    location = json['location'] ?? "";
    firstname = json['firstname'] ?? "";
    lastname = json['lastname'] ?? "";
    image = "";

    if (json["profileImage"] != null) {
      var imageArray = List<String>.from(json["profileImage"].map((x) => x));
      image = imageArray.length > 0
          ? Uri.parse(imageArray[0]).isAbsolute
              ? imageArray[0]
              : ""
          : "";
    }
    doctorUserName = json["userName"] ?? "";
    videoConsultationFee = json['fees'] ?? 0;
    registrationNumber = json['registrationNumber'] ?? "";
    if (json["rating"] != null) {
      double drRating = json['rating'] ?? 0;
      rating = drRating.toDouble();
    } else {
      rating = 0;
    }
    firstname = json['firstName'] ?? "";
    lastname = json['lastName'] ?? "";
    isConsultant = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['active'] = this.active;
    data['downloadProfileURL'] = this.downloadProfileURL;
    // data['address1'] = this.address1;
    // data['address2'] = this.address2;
    // data['businessPhone'] = this.businessPhone;
    // data['city'] = this.city;
    // data['comments'] = this.comments;
    // data['country'] = this.country;
    // data['createdBy'] = this.createdBy;
    // data['createdOn'] = this.createdOn;
    // data['createdBy'] = this.createdBy;
    // data['createdOn'] = this.createdOn;
    // data['doctorDesc'] = this.doctorDesc;
    data['doctorId'] = this.doctorId;
    data['userFullName'] = this.doctorName;
    data['education'] = this.education;
    // data['modifiedBy'] = this.modifiedBy;
    // data['modifiedOn'] = this.modifiedOn;
    data['specialities'] = List<dynamic>.from(this.speciality.map((x) => x));
    // data['startedWorkingOn'] = this.startedWorkingOn;
    // data['state'] = this.state;
    // data['status'] = this.status;
    // data['workingHours'] = List<dynamic>.from(this.workingHours.map((x) => x));
    // data['zipcode'] = this.zipcode;
    data['fees'] = this.videoConsultationFee;
    // data['availableDays'] =
    //     List<dynamic>.from(this.availableDays.map((x) => x));

    data['profileImage'] = this.image;
    data['registrationNumber'] = this.registrationNumber;
    data['rating'] = this.rating;
    data['location'] = this.location;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['doctorUserName'] = this.doctorUserName;
    return data;
  }
}
