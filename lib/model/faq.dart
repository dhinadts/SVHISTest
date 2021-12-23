class Faq {
  List<MemberShipFaq> memberShipFaq;
  List<Diabetes> diabetes;
  List<GNATFaqs> gnatFaqs;
  List<MemberShipFaq> memberShipSecondList;
  List<Goals> goalsList;
  Faq(
      {this.memberShipFaq,
      this.diabetes,
      this.memberShipSecondList,
      this.gnatFaqs,
      this.goalsList});

  Faq.fromJson(Map<String, dynamic> json) {
    if (json['MemberShip'] != null) {
      memberShipFaq = new List<MemberShipFaq>();
      json['MemberShip'].forEach((v) {
        memberShipFaq.add(new MemberShipFaq.fromJson(v));
      });
    }
    if (json['GNAT MOBILE APPLICATION FAQS'] != null) {
      memberShipSecondList = new List<MemberShipFaq>();
      json['GNAT MOBILE APPLICATION FAQS'].forEach((v) {
        memberShipSecondList.add(new MemberShipFaq.fromJson(v));
      });
    }

    if (json['GNAT FAQs'] != null) {
      gnatFaqs = new List<GNATFaqs>();
      json['GNAT FAQs'].forEach((v) {
        gnatFaqs.add(new GNATFaqs.fromJson(v));
      });
    }

    if (json['Goals'] != null) {
      goalsList = new List<Goals>();
      json['Goals'].forEach((v) {
        goalsList.add(new Goals.fromJson(v));
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
    if (this.memberShipSecondList != null) {
      data['GNAT MOBILE APPLICATION FAQS'] =
          this.memberShipSecondList.map((v) => v.toJson()).toList();
    }
    if (this.gnatFaqs != null) {
      data['GNAT FAQs'] = this.gnatFaqs.map((v) => v.toJson()).toList();
    }
    if (this.goalsList != null) {
      data['Goals'] = this.goalsList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MemberShipFaq {
  String title;
  String heading;
  List<String> subHeading;
  String get searchRepresentation => "${heading ?? ""} ${title ?? ""} ${subHeading?.join(" ") ?? ""}";

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

class GNATFaqs {
  String title;
  String heading;
  List<String> subHeading;
  String get searchRepresentation => "${title ?? ""} ${subHeading?.join(" ") ?? ""}";

  GNATFaqs({
    this.title,
    this.heading,
    this.subHeading,
  });

  GNATFaqs.fromJson(Map<String, dynamic> json) {
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

class Goals {
  String title;
  String text;
  
  String get searchRepresentation => "${title ?? ""} ${text ?? ""}";

  Goals({
    this.title,
    this.text,
  });

  Goals.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? "";
    text = json['text'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['text'] = this.text;
    return data;
  }
}

class Diabetes {
  String title;
  String heading;
  List<String> subHeading;
  String comments;
  List<String> commentArray;
  String get searchRepresentation => "${heading ?? ""} ${title ?? ""} ${subHeading?.join(" ")?.toLowerCase() ?? ""} ${comments ?? ""} ${commentArray?.join(" ")?.toLowerCase() ?? ""}";

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
