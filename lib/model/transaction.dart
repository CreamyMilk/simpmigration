class MyData {
  List<Results> results;

  MyData({this.results});

  MyData.fromJson(Map<String, dynamic> json) {
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
  int fId;
  String type;
  String floorNo;
  String unitNo;
  int rid;
  int monthId;
  String xyear;
  int rent;
  int waterBill;
  int electricBill;
  int gasBill;
  int securityBill;
  int utilityBill;
  int otherBill;
  int totalRent;
  String issueDate;
  String paidDate;
  int branchId;
  int billStatus;
  String addedDate;
  int fid;
  int uid;
  int status;
  int mId;
  String monthName;
  String rName;
  String rEmail;
  String rContact;
  String rAddress;
  String rNid;
  String rFloorNo;
  String rUnitNo;
  int rAdvance;
  int rRentPm;
  String rDate;
  Null rGoneDate;
  String rPassword;
  String image;
  int rStatus;
  int rMonth;
  int rYear;
  String rImage;
  String flFloor;
  String uUnit;

  Results(
      {this.sId,
      this.fId,
      this.type,
      this.floorNo,
      this.unitNo,
      this.rid,
      this.monthId,
      this.xyear,
      this.rent,
      this.waterBill,
      this.electricBill,
      this.gasBill,
      this.securityBill,
      this.utilityBill,
      this.otherBill,
      this.totalRent,
      this.issueDate,
      this.paidDate,
      this.branchId,
      this.billStatus,
      this.addedDate,
      this.fid,
      this.uid,
      this.status,
      this.mId,
      this.monthName,
      this.rName,
      this.rEmail,
      this.rContact,
      this.rAddress,
      this.rNid,
      this.rFloorNo,
      this.rUnitNo,
      this.rAdvance,
      this.rRentPm,
      this.rDate,
      this.rGoneDate,
      this.rPassword,
      this.image,
      this.rStatus,
      this.rMonth,
      this.rYear,
      this.rImage,
      this.flFloor,
      this.uUnit});

  Results.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fId = json['f_id'];
    type = json['type'];
    floorNo = json['floor_no'];
    unitNo = json['unit_no'];
    rid = json['rid'];
    monthId = json['month_id'];
    xyear = json['xyear'];
    rent = json['rent'];
    waterBill = json['water_bill'];
    electricBill = json['electric_bill'];
    gasBill = json['gas_bill'];
    securityBill = json['security_bill'];
    utilityBill = json['utility_bill'];
    otherBill = json['other_bill'];
    totalRent = json['total_rent'];
    issueDate = json['issue_date'];
    paidDate = json['paid_date'];
    branchId = json['branch_id'];
    billStatus = json['bill_status'];
    addedDate = json['added_date'];
    fid = json['fid'];
    uid = json['uid'];
    status = json['status'];
    mId = json['m_id'];
    monthName = json['month_name'];
    rName = json['r_name'];
    rEmail = json['r_email'];
    rContact = json['r_contact'];
    rAddress = json['r_address'];
    rNid = json['r_nid'];
    rFloorNo = json['r_floor_no'];
    rUnitNo = json['r_unit_no'];
    rAdvance = json['r_advance'];
    rRentPm = json['r_rent_pm'];
    rDate = json['r_date'];
    rGoneDate = json['r_gone_date'];
    rPassword = json['r_password'];
    image = json['image'];
    rStatus = json['r_status'];
    rMonth = json['r_month'];
    rYear = json['r_year'];
    rImage = json['r_image'];
    flFloor = json['fl_floor'];
    uUnit = json['u_unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['f_id'] = this.fId;
    data['type'] = this.type;
    data['floor_no'] = this.floorNo;
    data['unit_no'] = this.unitNo;
    data['rid'] = this.rid;
    data['month_id'] = this.monthId;
    data['xyear'] = this.xyear;
    data['rent'] = this.rent;
    data['water_bill'] = this.waterBill;
    data['electric_bill'] = this.electricBill;
    data['gas_bill'] = this.gasBill;
    data['security_bill'] = this.securityBill;
    data['utility_bill'] = this.utilityBill;
    data['other_bill'] = this.otherBill;
    data['total_rent'] = this.totalRent;
    data['issue_date'] = this.issueDate;
    data['paid_date'] = this.paidDate;
    data['branch_id'] = this.branchId;
    data['bill_status'] = this.billStatus;
    data['added_date'] = this.addedDate;
    data['fid'] = this.fid;
    data['uid'] = this.uid;
    data['status'] = this.status;
    data['m_id'] = this.mId;
    data['month_name'] = this.monthName;
    data['r_name'] = this.rName;
    data['r_email'] = this.rEmail;
    data['r_contact'] = this.rContact;
    data['r_address'] = this.rAddress;
    data['r_nid'] = this.rNid;
    data['r_floor_no'] = this.rFloorNo;
    data['r_unit_no'] = this.rUnitNo;
    data['r_advance'] = this.rAdvance;
    data['r_rent_pm'] = this.rRentPm;
    data['r_date'] = this.rDate;
    data['r_gone_date'] = this.rGoneDate;
    data['r_password'] = this.rPassword;
    data['image'] = this.image;
    data['r_status'] = this.rStatus;
    data['r_month'] = this.rMonth;
    data['r_year'] = this.rYear;
    data['r_image'] = this.rImage;
    data['fl_floor'] = this.flFloor;
    data['u_unit'] = this.uUnit;
    return data;
  }
}
