class MpesaConfirmResponse {
  List<Results> results;

  MpesaConfirmResponse({this.results});

  MpesaConfirmResponse.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String sId;
  String transactionType;
  String transID;
  String transTime;
  String transAmount;
  String businessShortCode;
  String billRefNumber;
  String invoiceNumber;
  String orgAccountBalance;
  String thirdPartyTransID;
  String mSISDN;
  String firstName;
  String middleName;
  String lastName;

  Results(
      {this.sId,
      this.transactionType,
      this.transID,
      this.transTime,
      this.transAmount,
      this.businessShortCode,
      this.billRefNumber,
      this.invoiceNumber,
      this.orgAccountBalance,
      this.thirdPartyTransID,
      this.mSISDN,
      this.firstName,
      this.middleName,
      this.lastName});

  Results.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    transactionType = json['TransactionType'];
    transID = json['TransID'];
    transTime = json['TransTime'];
    transAmount = json['TransAmount'];
    businessShortCode = json['BusinessShortCode'];
    billRefNumber = json['BillRefNumber'];
    invoiceNumber = json['InvoiceNumber'];
    orgAccountBalance = json['OrgAccountBalance'];
    thirdPartyTransID = json['ThirdPartyTransID'];
    mSISDN = json['MSISDN'];
    firstName = json['FirstName'];
    middleName = json['MiddleName'];
    lastName = json['LastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['TransactionType'] = this.transactionType;
    data['TransID'] = this.transID;
    data['TransTime'] = this.transTime;
    data['TransAmount'] = this.transAmount;
    data['BusinessShortCode'] = this.businessShortCode;
    data['BillRefNumber'] = this.billRefNumber;
    data['InvoiceNumber'] = this.invoiceNumber;
    data['OrgAccountBalance'] = this.orgAccountBalance;
    data['ThirdPartyTransID'] = this.thirdPartyTransID;
    data['MSISDN'] = this.mSISDN;
    data['FirstName'] = this.firstName;
    data['MiddleName'] = this.middleName;
    data['LastName'] = this.lastName;
    return data;
  }
}
