class ServicesNet {
  List<ServicesArray> servicesArray;

  ServicesNet({this.servicesArray});

  ServicesNet.fromJson(Map<String, dynamic> json) {
    if (json['servicesArray'] != null) {
      servicesArray = new List<ServicesArray>();
      json['servicesArray'].forEach((v) {
        servicesArray.add(new ServicesArray.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.servicesArray != null) {
      data['servicesArray'] =
          this.servicesArray.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServicesArray {
  String rank;
  String shopName;
  String address;
  String contact;
  String description;
  String lat;
  String long;

  ServicesArray(
      {this.rank,
      this.shopName,
      this.address,
      this.contact,
      this.description,
      this.lat,
      this.long});

  ServicesArray.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    shopName = json['shopName'];
    address = json['address'];
    contact = json['contact'];
    description = json['description'];
    lat = json['Lat'];
    long = json['Long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rank'] = this.rank;
    data['shopName'] = this.shopName;
    data['address'] = this.address;
    data['contact'] = this.contact;
    data['description'] = this.description;
    data['Lat'] = this.lat;
    data['Long'] = this.long;
    return data;
  }
}
