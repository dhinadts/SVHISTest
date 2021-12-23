class GoeResponseModel {
//  Statename statename;
  String distance;
  String elevation;
  String state;
  String latt;
  String city;
  String prov;
  String geocode;
  String geonumber;
  String country;
  String staddress;
  String stnumber;
  String inlatt;
  String timezone;
  String region;
  String longt;
  String confidence;
  String inlongt;
  String clas;
  String status;
  String altgeocode;
  String postal;

  GoeResponseModel(
      {this.distance,
      this.elevation,
      this.state,
      this.latt,
      this.city,
      this.prov,
      this.geocode,
      this.geonumber,
      this.country,
      this.staddress,
      this.inlatt,
      this.timezone,
      this.region,
      this.longt,
      this.confidence,
      this.inlongt,
      this.clas,
      this.postal,
      this.altgeocode});

  GoeResponseModel.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    elevation = json['elevation'];
    state = json['state'];
    latt = json['latt'];
    city = json['city'];
    prov = json['prov'];
    geocode = json['geocode'];
    geonumber = json['geonumber'];
    stnumber = json['stnumber']?.toString() ?? "";
    country = json['country'];
    staddress = json['staddress']?.toString() ?? "";
    inlatt = json['inlatt'];
    timezone = json['timezone'];
    region = json['region'];
    longt = json['longt'];
    confidence = json['confidence'];
    inlongt = json['inlongt'];
    clas = json['class'].toString();
    altgeocode = json['altgeocode'];
    postal = json['postal'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['distance'] = this.distance;
    data['elevation'] = this.elevation;
    data['state'] = this.state;
    data['latt'] = this.latt;
    data['city'] = this.city;
    data['prov'] = this.prov;
    data['geocode'] = this.geocode;
    data['geonumber'] = this.geonumber;
    data['country'] = this.country;
    data['staddress'] = this.staddress;
    data['inlatt'] = this.inlatt;
    data['timezone'] = this.timezone;
    data['region'] = this.region;
    data['longt'] = this.longt;
    data['confidence'] = this.confidence;
    data['inlongt'] = this.inlongt;
    data['class'] = this.clas;
    data['altgeocode'] = this.altgeocode;
    data['stnumber'] = this.stnumber;
    data['postal'] = this.postal;
    return data;
  }
}

/*
class Statename {


  Statename({});

Statename.fromJson(Map<String, dynamic> json) {
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}
}*/
