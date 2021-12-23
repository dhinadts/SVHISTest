class EntryLogModel {
  String entryLogId;
  String userId;
  String inTime;
  var outTime;
  double temp;
  String modeOfVisit;
  var refScheduleId;
  String status;
  String entryDate;
  var latlong;
  String unit;
  var statusCode;
  var reason;
  var deviceName;
  var deviceLocation;
  var modeOfEntry;
  var mask;
  var firstName;
  var lastName;
  var imgFile;
  var emailId;
  var phoneNo;
  var address;
  var reasonForVisit;
  var personToMeet;
  var gotAppoitnment;
  String timeStamp;
  var userDepartment;
  var departmentName;
  var employeeId;
  var facialImage;

  EntryLogModel(
      {this.entryLogId,
      this.userId,
      this.inTime,
      this.outTime,
      this.temp,
      this.modeOfVisit,
      this.refScheduleId,
      this.status,
      this.entryDate,
      this.latlong,
      this.unit,
      this.statusCode,
      this.reason,
      this.deviceName,
      this.deviceLocation,
      this.modeOfEntry,
      this.mask,
      this.firstName,
      this.lastName,
      this.imgFile,
      this.emailId,
      this.phoneNo,
      this.address,
      this.reasonForVisit,
      this.personToMeet,
      this.gotAppoitnment,
      this.timeStamp,
      this.userDepartment,
      this.departmentName,
      this.employeeId,
      this.facialImage});

  EntryLogModel.fromJson(Map<String, dynamic> json) {
    entryLogId = json['entryLogId'];
    userId = json['userId'];
    inTime = json['inTime'];
    outTime = json['outTime'];
    temp = json['temp'];
    modeOfVisit = json['modeOfVisit'];
    refScheduleId = json['refScheduleId'];
    status = json['status'];
    entryDate = json['entryDate'];
    latlong = json['latlong'];
    unit = json['unit'];
    statusCode = json['statusCode'];
    reason = json['reason'];
    deviceName = json['deviceName'];
    deviceLocation = json['deviceLocation'];
    modeOfEntry = json['modeOfEntry'];
    mask = json['mask'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    imgFile = json['imgFile'];
    emailId = json['emailId'];
    phoneNo = json['phoneNo'];
    address = json['address'];
    reasonForVisit = json['reasonForVisit'];
    personToMeet = json['personToMeet'];
    gotAppoitnment = json['gotAppoitnment'];
    timeStamp = json['timeStamp'];
    userDepartment = json['userDepartment'];
    departmentName = json['departmentName'];
    employeeId = json['employeeId'];
    facialImage = json['facialImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entryLogId'] = this.entryLogId;
    data['userId'] = this.userId;
    data['inTime'] = this.inTime;
    data['outTime'] = this.outTime;
    data['temp'] = this.temp;
    data['modeOfVisit'] = this.modeOfVisit;
    data['refScheduleId'] = this.refScheduleId;
    data['status'] = this.status;
    data['entryDate'] = this.entryDate;
    data['latlong'] = this.latlong;
    data['unit'] = this.unit;
    data['statusCode'] = this.statusCode;
    data['reason'] = this.reason;
    data['deviceName'] = this.deviceName;
    data['deviceLocation'] = this.deviceLocation;
    data['modeOfEntry'] = this.modeOfEntry;
    data['mask'] = this.mask;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['imgFile'] = this.imgFile;
    data['emailId'] = this.emailId;
    data['phoneNo'] = this.phoneNo;
    data['address'] = this.address;
    data['reasonForVisit'] = this.reasonForVisit;
    data['personToMeet'] = this.personToMeet;
    data['gotAppoitnment'] = this.gotAppoitnment;
    data['timeStamp'] = this.timeStamp;
    data['userDepartment'] = this.userDepartment;
    data['departmentName'] = this.departmentName;
    data['employeeId'] = this.employeeId;
    data['facialImage'] = this.facialImage;
    return data;
  }
}
