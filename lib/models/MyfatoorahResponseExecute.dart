import 'DataExecute.dart';

class MyfatoorahResponseExecute {
  bool isSuccess;
  DataExecute? data;
  String? validationErrors;

  MyfatoorahResponseExecute(
      {required this.isSuccess, this.validationErrors, this.data});

  factory MyfatoorahResponseExecute.fromJson(Map<String, dynamic> json) {
    return MyfatoorahResponseExecute(
      isSuccess: json['IsSuccess'],
      validationErrors: json['ValidationErrors'] == null
          ? 'Validation Success'
          : json['ValidationErrors'],
      data: DataExecute.fromJson(json['Data']),
    );
  }
}
