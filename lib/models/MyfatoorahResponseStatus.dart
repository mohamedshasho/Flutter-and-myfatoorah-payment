import 'DataStatus.dart';
import 'InvoiceTransactionsData.dart';

class MyfatoorahResponseStatus {
  bool isSuccess;
  DataStatus? data;
  String? validationErrors;
  String? message;
  InvoiceTransactionsData? invoiceTransactions;

  MyfatoorahResponseStatus(
      {required this.isSuccess,
      this.validationErrors,
      this.message,
      this.data,
      this.invoiceTransactions});

  factory MyfatoorahResponseStatus.fromJson(Map<String, dynamic> json) {
    List<dynamic> tran = json['Data']['InvoiceTransactions'];
    print('Transactions Length: ' + tran.length.toString());
    return MyfatoorahResponseStatus(
      isSuccess: json['IsSuccess'],
      validationErrors: json['ValidationErrors'] == null
          ? 'Validation Success'
          : json['ValidationErrors'],
      data: DataStatus.fromJson(json['Data']),
      invoiceTransactions: InvoiceTransactionsData.fromJson(tran[0]),
    );
  }
}
