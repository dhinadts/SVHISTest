class Advertisement {
  bool active;
  String adSizeType;
  String advDisplayPage;
  String advertiseType;
  String anchorType;
  String childDirected;
  String comments;
  String contentUrl;
  String createdBy;
  String createdOn;
  bool enableCloseVideo;
  String expiresOn;
  String height;
  String horizontalAnchorOffset;
  String hwSizeType;
  String id;
  String mediaUrl;
  String minVideoDuration;
  String modifiedBy;
  String modifiedOn;
  bool showSkipVideo;
  String verticalAnchorOffset;
  String width;
  double interstitialDuration;

  Advertisement(
      {this.active,
      this.adSizeType,
      this.advDisplayPage,
      this.advertiseType,
      this.anchorType,
      this.childDirected,
      this.comments,
      this.contentUrl,
      this.createdBy,
      this.createdOn,
      this.enableCloseVideo,
      this.expiresOn,
      this.height,
      this.horizontalAnchorOffset,
      this.hwSizeType,
      this.id,
      this.mediaUrl,
      this.minVideoDuration,
      this.modifiedBy,
      this.modifiedOn,
      this.showSkipVideo,
      this.verticalAnchorOffset,
      this.width,
      this.interstitialDuration});

  Advertisement.fromJson(Map<String, dynamic> json) {
    active = json['active'] ?? false;
    adSizeType = json['adSizeType'] ?? "";
    advDisplayPage = json['advDisplayPage'] ?? "";
    advertiseType = json['advertiseType'] ?? "";
    anchorType = json['anchorType'] ?? "";
    childDirected = json['childDirected'] ?? "";
    comments = json['comments'] ?? "";
    contentUrl = json['contentUrl'] ?? "";
    createdBy = json['createdBy'] ?? "";
    createdOn = json['createdOn'] ?? "";
    createdBy = json['createdBy'] ?? "";
    createdOn = json['createdOn'] ?? "";
    enableCloseVideo = json['enableCloseVideo'] ?? false;
    expiresOn = json['expiresOn'] ?? "";
    id = json['id'] ?? "";
    height = json['height'] ?? "";
    modifiedBy = json['modifiedBy'] ?? "";
    modifiedOn = json['modifiedOn'] ?? "";
    horizontalAnchorOffset = json['horizontalAnchorOffset'] ?? "";
    hwSizeType = json['hwSizeType'] ?? "";
    mediaUrl = json['mediaUrl'] ?? "";
    minVideoDuration = json['minVideoDuration'] ?? "";
    showSkipVideo = json['showSkipVideo'] ?? false;
    verticalAnchorOffset = json['verticalAnchorOffset'] ?? "";
    width = json['width'] ?? "";
    interstitialDuration = json['interstitialDuration'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['adSizeType'] = this.adSizeType;
    data['advDisplayPage'] = this.advDisplayPage;
    data['advertiseType'] = this.advertiseType;
    data['anchorType'] = this.anchorType ?? "";
    data['childDirected'] = this.childDirected;
    data['comments'] = this.comments;
    data['contentUrl'] = this.contentUrl;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['enableCloseVideo'] = this.enableCloseVideo;
    data['expiresOn'] = this.expiresOn;
    data['id'] = this.id;
    data['height'] = this.height;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['horizontalAnchorOffset'] = this.horizontalAnchorOffset;
    data['hwSizeType'] = this.hwSizeType;
    data['mediaUrl'] = this.mediaUrl;
    data['minVideoDuration'] = this.minVideoDuration;
    data['showSkipVideo'] = this.showSkipVideo;
    data['verticalAnchorOffset'] = this.verticalAnchorOffset;
    data['width'] = this.width;
    data['interstitialDuration'] = this.interstitialDuration;
    return data;
  }
}
