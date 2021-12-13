class MyfatoorahResponseInitiate {
  bool? isSuccess;
  List<DataInitiate?> data = [];
  String? validationErrors;
}

class DataInitiate {
  int paymentMethodId;
  String paymentMethodAr;
  double serviceCharge;
  String imageUrl;
  DataInitiate(
      {required this.paymentMethodId,
      required this.paymentMethodAr,
      required this.imageUrl,
      required this.serviceCharge});
  factory DataInitiate.fromJson(Map<String, dynamic> json) {
    return DataInitiate(
        paymentMethodId: json['PaymentMethodId'],
        paymentMethodAr: json['PaymentMethodAr'],
        serviceCharge: json['ServiceCharge'],
        imageUrl: json['ImageUrl']);
  }
}
