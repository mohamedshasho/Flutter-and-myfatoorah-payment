import 'DataDirect.dart';

class MyfatoorahResponseDirect {
  bool isSuccess;
  DataDirect? data;
  String? message;
  // String paymentUrl;
  MyfatoorahResponseDirect({this.data, required this.isSuccess, this.message});

  factory MyfatoorahResponseDirect.fromjson(Map<String, dynamic> json) {
    return MyfatoorahResponseDirect(
      isSuccess: json['IsSuccess'],
      message: json['Message'],
      data: json['Data'] != null ? DataDirect.fromJson(json['Data']) : null,
      // paymentUrl: json['Data']['PaymentURL'],
    );
  }
}
