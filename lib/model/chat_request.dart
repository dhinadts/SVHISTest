class ChartRequest {
  String chartBasedOn;
  String reportType;
  String reportCategory;
  String reportOccurence;
  Null startDate;
  Null endDate;
  String chartCategory;
  bool ignoreNull;

  ChartRequest(
      {this.chartBasedOn,
      this.reportType,
      this.reportCategory,
      this.reportOccurence,
      this.startDate,
      this.endDate,
      this.chartCategory,
      this.ignoreNull});

  ChartRequest.fromJson(Map<String, dynamic> json) {
    chartBasedOn = json['chartBasedOn'];
    reportType = json['reportType'];
    reportCategory = json['reportCategory'];
    reportOccurence = json['reportOccurence'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    chartCategory = json['chartCategory'];
    ignoreNull = json['ignoreNull'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chartBasedOn'] = this.chartBasedOn;
    data['reportType'] = this.reportType;
    data['reportCategory'] = this.reportCategory;
    data['reportOccurence'] = this.reportOccurence;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['chartCategory'] = this.chartCategory;
    data['ignoreNull'] = this.ignoreNull;
    return data;
  }
}
