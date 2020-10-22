class Otploginresponse {
  int message;
  Info info;

  Otploginresponse({this.message, this.info});

  Otploginresponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.info != null) {
      data['info'] = this.info.toJson();
    }
    return data;
  }
}

class Info {
  String username;
  String uid;
  String mobile;
  Transaction transaction;
  List<String> complains;
  List<String> services;
  Rent rent;
  String lastIssue;
  String lastService;

  Info(
      {this.username,
      this.uid,
      this.mobile,
      this.transaction,
      this.complains,
      this.services,
      this.rent,
      this.lastIssue,
      this.lastService});

  Info.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    uid = json['uid'];
    mobile = json['mobile'];
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
    complains = json['complains'].cast<String>();
    services = json['services'].cast<String>();
    rent = json['rent'] != null ? new Rent.fromJson(json['rent']) : null;
    lastIssue = json['lastIssue'];
    lastService = json['lastService'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['uid'] = this.uid;
    data['mobile'] = this.mobile;
    if (this.transaction != null) {
      data['transaction'] = this.transaction.toJson();
    }
    data['complains'] = this.complains;
    data['services'] = this.services;
    if (this.rent != null) {
      data['rent'] = this.rent.toJson();
    }
    data['lastIssue'] = this.lastIssue;
    data['lastService'] = this.lastService;
    return data;
  }
}

class Transaction {
  String title;
  List<Data> data;

  Transaction({this.title, this.data});

  Transaction.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String month;
  String time;
  Rec rec;

  Data({this.month, this.time, this.rec});

  Data.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    time = json['time'];
    rec = json['rec'] != null ? new Rec.fromJson(json['rec']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['time'] = this.time;
    if (this.rec != null) {
      data['rec'] = this.rec.toJson();
    }
    return data;
  }
}

class Rec {
  String username;
  String branch;
  String house;
  String receiptNumber;
  String description;
  int amount;

  Rec(
      {this.username,
      this.branch,
      this.house,
      this.receiptNumber,
      this.description,
      this.amount});

  Rec.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    branch = json['branch'];
    house = json['house'];
    receiptNumber = json['receiptNumber'];
    description = json['description'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['branch'] = this.branch;
    data['house'] = this.house;
    data['receiptNumber'] = this.receiptNumber;
    data['description'] = this.description;
    data['amount'] = this.amount;
    return data;
  }
}

class Rent {
  String month;
  int rentDue;
  bool rentStatus;

  Rent({this.month, this.rentDue, this.rentStatus});

  Rent.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    rentDue = json['rentDue'];
    rentStatus = json['rentStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['rentDue'] = this.rentDue;
    data['rentStatus'] = this.rentStatus;
    return data;
  }
}