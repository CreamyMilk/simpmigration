class PaymentResponse {
  int paymentCode;
  String description;

  PaymentResponse({this.paymentCode, this.description});

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    paymentCode = json['payment_code'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_code'] = this.paymentCode;
    data['description'] = this.description;
    return data;
  }
}
