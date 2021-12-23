class event {
  final String eventname;
  final String startdate;
  final String enddate;

  event(
      { this.eventname,
        this.startdate,
        this.enddate}
      );
  factory event.fromJson(Map<String, dynamic> json) {
    return event(
      eventname: json['eventname']as String,
      startdate: json['startdate']as String,
      enddate: json['enddate']as String,
    );
  }

  @override
  String toString() {
    return 'event{eventname: $eventname, startdate: $startdate, enddate: $enddate}';
  }

}