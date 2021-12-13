class DataDirect {
  String status;
  String? errorMessage;
  String? paymentId;
  //String Token;
  String? paymentURL;
  DataDirect(
      {required this.status,
      this.paymentId,
      this.paymentURL,
      this.errorMessage});

  factory DataDirect.fromJson(Map<String, dynamic> json) {
    return DataDirect(
      status: json['Status'],
      paymentId: json['PaymentId'],
      paymentURL: json['PaymentURL'],
      errorMessage: json['ErrorMessage'],
    );
  }
}
