import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:simpmigration/constants.dart';

class PaymentUpdateModel {
  Token token;
  Rent rent;
  Transaction transaction;
  String lastIssue;

  PaymentUpdateModel({this.token, this.rent, this.transaction, this.lastIssue});

  PaymentUpdateModel.fromJson(Map<String, dynamic> json) {
    token = json['token'] != null ? new Token.fromJson(json['token']) : null;
    rent = json['rent'] != null ? new Rent.fromJson(json['rent']) : null;
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
    lastIssue = json['lastIssue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.token != null) {
      data['token'] = this.token.toJson();
    }
    if (this.rent != null) {
      data['rent'] = this.rent.toJson();
    }
    if (this.transaction != null) {
      data['transaction'] = this.transaction.toJson();
    }
    data['lastIssue'] = this.lastIssue;
    return data;
  }
}

class Token {
  Null accountReference;
  String fullName;
  int idService;
  int idPaymentForm;
  List<dynamic> colPrepayment;
  bool prepayment;

  Token(
      {this.accountReference,
      this.fullName,
      this.idService,
      this.idPaymentForm,
      this.colPrepayment,
      this.prepayment});

  Token.fromJson(Map<String, dynamic> json) {
    accountReference = json['accountReference'];
    fullName = json['fullName'];
    idService = json['idService'];
    idPaymentForm = json['idPaymentForm'];
    colPrepayment = json['colPrepayment'];
    prepayment = json['prepayment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountReference'] = this.accountReference;
    data['fullName'] = this.fullName;
    data['idService'] = this.idService;
    data['idPaymentForm'] = this.idPaymentForm;
    data['colPrepayment'] = this.colPrepayment;
    data['prepayment'] = this.prepayment;
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
    rentStatus = json['rentStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = this.account;
    data['month'] = this.month;
    data['rentDue'] = this.rentDue;
    data['rentStatus'] = this.rentStatus;
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
      data = [];
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
    rentStatus = json['rentStatus'];
    rec = json['rec'] != null ? new Rec.fromJson(json['rec']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['time'] = this.time;
    data['year'] = this.year;
    data['rs'] = this.rs;
    data['rentStatus'] = this.rentStatus;
    if (this.rec != null) {
      data['rec'] = this.rec.toJson();
    }
    return data;
  }
}

class Rec {
  String username;
  String house;
  String time;
  String branch;
  String receiptNumber;
  String description;
  int amount;

  Rec(
      {this.username,
      this.house,
      this.time,
      this.branch,
      this.receiptNumber,
      this.description,
      this.amount});

  Rec.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    house = json['house'];
    time = json['time'];
    branch = json['branch'];
    receiptNumber = json['receiptNumber'];
    description = json['description'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['house'] = this.house;
    data['time'] = this.time;
    data['branch'] = this.branch;
    data['receiptNumber'] = this.receiptNumber;
    data['description'] = this.description;
    data['amount'] = this.amount;
    return data;
  }
}

Future<void> getLatestTrans() async {
  PaymentUpdateModel data;
  String transaction;
  String tokenStore;
  var userBox = Hive.box(Constants.HiveBoxName);
  var uid = userBox.get(Constants.UserIDStore, defaultValue: 0);
  if (uid != 0) {
    final response = await http.post(
      Uri.parse("http://92.222.201.138:9003/getnewtrans"),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      },
      body: jsonEncode(
        {
          'uid': uid, //mobile,
        },
      ),
    );
    var myjson = json.decode(response.body);
    data = PaymentUpdateModel.fromJson(myjson);
    userBox.put(Constants.RentPayableStore, data.rent.toJson());
    tokenStore = jsonEncode(data.token.toJson());
    transaction = jsonEncode(data.transaction.toJson());
    userBox.put(Constants.TransactionStore, transaction);
    userBox.put(Constants.PowerTokensStore, tokenStore); //lastIssue
    userBox.put(Constants.ReportedIssuesStore, myjson["lastIssue"]);

    print("Transactions Added");
  }
}
