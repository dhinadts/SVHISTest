import 'dart:convert';

class Contact {
  String userName;
  String emailAddress;
  String address;
  String phone;
  String country;
  String state;
  String city;
  String zip;

  Contact fromJson(String json) {
    // Map<String, dynamic> map = JSON.decode(json);
    Map<String, dynamic> map = jsonDecode(json);
    var contact = new Contact();
    contact.userName = map['userName'];
    contact.address = map['address'];
    contact.phone = map['phone'];
    contact.emailAddress = map['emailAddress'];
    contact.country = map['country'];
    contact.state = map['state'];
    contact.city = map['city'];
    contact.zip = map['zip'];

    return contact;
  }

  String toJson(Contact contact) {
    var mapData = new Map();
    mapData["userName"] = contact.userName;
    //mapData["dob"] = new DateFormat.yMd().format(contact.dob);
    mapData["address"] = contact.address;
    mapData["emailAddress"] = contact.emailAddress;
    mapData["phone"] = contact.phone;
    mapData["country"] = contact.country;
    mapData["state"] = contact.state;
    mapData["city"] = contact.city;
    mapData["zip"] = contact.zip;
    String json = jsonEncode(mapData);
    // print(json);
    return json;
  }
}
