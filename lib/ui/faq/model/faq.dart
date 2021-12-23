class Faq {
  List<MemberShipFaq> memberShipFaq;
  List<Diabetes> diabetes;

  Faq({this.memberShipFaq, this.diabetes});

  Faq.fromJson(Map<String, dynamic> json) {
    if (json['MemberShip'] != null) {
      memberShipFaq = new List<MemberShipFaq>();
      json['MemberShip'].forEach((v) {
        memberShipFaq.add(new MemberShipFaq.fromJson(v));
      });
    }
    if (json['Diabetes'] != null) {
      diabetes = new List<Diabetes>();
      json['Diabetes'].forEach((v) {
        diabetes.add(new Diabetes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.memberShipFaq != null) {
      data['MemberShip'] = this.memberShipFaq.map((v) => v.toJson()).toList();
    }
    if (this.diabetes != null) {
      data['Diabetes'] = this.diabetes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MemberShipFaq {
  String title;
  String heading;
  List<String> subHeading;

  MemberShipFaq({
    this.title,
    this.heading,
    this.subHeading,
  });

  MemberShipFaq.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? "";
    heading = json['heading'] ?? "";
    subHeading = json['subHeading']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['heading'] = this.heading;
    data['subHeading'] = this.subHeading;
    return data;
  }
}

class Diabetes {
  String title;
  String heading;
  List<String> subHeading;
  String comments;
  List<String> commentArray;

  Diabetes({
    this.title,
    this.heading,
    this.subHeading,
    this.comments,
    this.commentArray,
  });

  Diabetes.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? "";
    heading = json['heading'] ?? "";
    subHeading = json['subHeading']?.cast<String>();
    comments = json['comments'] ?? "";
    commentArray = json['commentArray']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['heading'] = this.heading;
    data['subHeading'] = this.subHeading;
    data['comments'] = this.comments;
    data['commentArray'] = this.commentArray;
    return data;
  }
}
