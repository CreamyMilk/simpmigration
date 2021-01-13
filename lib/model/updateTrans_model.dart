class UpdateTransModel {
  Rent rent;
  Transaction transaction;

  UpdateTransModel({this.rent, this.transaction});

  UpdateTransModel.fromJson(Map<String, dynamic> json) {
    rent = json['rent'] != null ? new Rent.fromJson(json['rent']) : null;
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rent != null) {
      data['rent'] = this.rent.toJson();
    }
    if (this.transaction != null) {
      data['transaction'] = this.transaction.toJson();
    }
    return data;
  }
}

class Rent {
  String account;
  String month;
  int rentDue;
  bool rentStatus;

  Rent({this.account, this.month, this.rentDue, this.rentStatus});

  Rent.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    month = json['month'];
    rentDue = json['rentDue'];
    rentStatus = json['rent_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = this.account;
    data['month'] = this.month;
    data['rentDue'] = this.rentDue;
    data['rent_status'] = this.rentStatus;
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
      // ignore: deprecated_member_use
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
  String year;
  int rs;
  bool rentStatus;
  Rec rec;

  Data({this.month, this.time, this.year, this.rs, this.rentStatus, this.rec});

  Data.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    time = json['time'];
    year = json['year'];
    rs = json['rs'];
    rentStatus = json['rent_status'];
    rec = json['rec'] != null ? new Rec.fromJson(json['rec']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['time'] = this.time;
    data['year'] = this.year;
    data['rs'] = this.rs;
    data['rent_status'] = this.rentStatus;
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
