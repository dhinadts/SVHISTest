class FileDetails {
  String attachmentId;
  String fileName;
  String fileType;
  String attachmentUrl;

  FileDetails({
    this.attachmentId,
    this.fileName,
    this.fileType,
    this.attachmentUrl,
  });

  FileDetails.fromJson(Map<String, dynamic> json) {
    attachmentId = json['attachmentId'] ?? "";
    fileName = json['fileName'] ?? "";
    fileType = json['fileType'] ?? "";
    attachmentUrl = json['attachmentUrl'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attachmentId'] = this.attachmentId;
    data['fileName'] = this.fileName;
    data['fileType'] = this.fileType;
    data['attachmentUrl'] = this.attachmentUrl;

    return data;
  }
}

class NotesDataUDT {
  String comments;
  List<FileDetails> files;
  String title;

  NotesDataUDT({
    this.comments,
    this.title,
    this.files,
  });

  NotesDataUDT.fromJson(Map<String, dynamic> json) {
    comments = json['comments'];
    title = json['title'] ?? "";
    files = json['files'] != null
        ? json['files']
            .map<FileDetails>((x) => FileDetails.fromJson(x))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['comments'] = this.comments;
    data['title'] = this.title;
    data['files'] = this.files;
    return data;
  }
}

class SmartNotesModel {
  String createdBy;
  String createdOn;
  String departmentName;
  String entityName;
  String modifiedBy;
  String modifiedOn;
  NotesDataUDT notesData;
  String notesId;
  String notesType;
  String userName;
  bool isExpanded;
  bool isImageRemoved;
  bool isVideoRemoved;
  bool isAudioRemoved;
  bool pinned;
  SmartNotesModel(
      {this.createdBy,
      this.createdOn,
      this.departmentName,
      this.entityName,
      this.modifiedBy,
      this.modifiedOn,
      this.notesData,
      this.notesId,
      this.notesType,
      this.userName,
      this.isExpanded,
      this.isImageRemoved,
      this.isVideoRemoved,
      this.isAudioRemoved,
      this.pinned});

  SmartNotesModel.fromJson(Map<String, dynamic> json) {
    createdBy = json['createdBy'];
    createdOn = json['createdOn'] ?? "";
    departmentName = json['departmentName'] ?? "";
    entityName = json['entityName'] ?? "";
    modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    notesData = json['notesData'] != null
        ? new NotesDataUDT.fromJson(json['notesData'])
        : null;
    notesId = json['notesId'];
    notesType = json['notesType'];
    userName = json['userName'];
    isExpanded = false;
    isImageRemoved = false;
    isVideoRemoved = false;
    isAudioRemoved = false;
    pinned = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['departmentName'] = this.departmentName;
    data['entityName'] = this.entityName;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['notesData'] = this.notesData;
    data['notesId'] = this.notesId;
    data['notesType'] = this.notesType;
    data['userName'] = this.userName;
    return data;
  }
}

class NotesAttachment {
  String notesId;
  String attachmentInfoDate;
  int attachmentOrder;
  String createdOn;
  String fileLocation;
  String fileName;
  String fileType;

  NotesAttachment({
    this.notesId,
    this.attachmentInfoDate,
    this.attachmentOrder,
    this.createdOn,
    this.fileLocation,
    this.fileName,
    this.fileType,
  });

  NotesAttachment.fromJson(Map<String, dynamic> json) {
    notesId = json['notesId'];
    attachmentInfoDate = json['attachmentInfoDate'] ?? "";
    attachmentOrder = json['attachmentOrder'];
    createdOn = json['createdOn'] ?? "";
    fileLocation = json['fileLocation'];
    fileName = json['fileName'] ?? "";
    fileType = json['fileType'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['notesId'] = this.notesId;
    data['attachmentInfoDate'] = this.attachmentInfoDate;
    data['attachmentOrder'] = this.attachmentOrder;
    data['createdOn'] = this.createdOn;
    data['fileLocation'] = this.fileLocation;
    data['fileName'] = this.fileName;
    data['fileType'] = this.fileType;
    return data;
  }
}
