class DoctorAvailability {
  String availableDate;
  List<DoctorAvailabilitySlot> slots;
  DoctorAvailability({
    this.availableDate,
    this.slots,
  });
  DoctorAvailability.fromJson(Map<String, dynamic> data) {
    availableDate = data['availableDate'];
    slots = (data['slots'] as List)
        ?.map((e) => e == null
            ? null
            : DoctorAvailabilitySlot.fromJson(e as Map<String, dynamic>))
        ?.toList();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['availableDate'] = this.availableDate;
    data['slots'] = this.slots;
    return data;
  }
}

class DoctorAvailabilitySlot {
  String startTime;
  String endTime;
  String availabilityStatus;
  String id;
  bool isPast = false;
  String slotStatus;

  DoctorAvailabilitySlot(
      {this.startTime, this.endTime, this.availabilityStatus, this.id,this.isPast});
  DoctorAvailabilitySlot.fromJson(Map<String, dynamic> data) {
    startTime = data['startTime'] ?? "";
    endTime = data['endTime'] ?? "";
    availabilityStatus = data['availabilityStatus'] ?? "";
    id = data['id'] ?? "";
    slotStatus = data['slotStatus'] ?? "";
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['availabilityStatus'] = this.availabilityStatus;
    data['id'] = this.id;
    data['slotStatus'] = this.slotStatus;
    return data;
  }
}
