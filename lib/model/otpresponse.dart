class OtpResponse {
  int messageCode;
  String description;

  OtpResponse({this.messageCode, this.description});

  OtpResponse.fromJson(Map<String, dynamic> json) {
    messageCode = json['message_code'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message_code'] = this.messageCode;
    data['description'] = this.description;
    return data;
  }
}
