class InvoiceTransactionsData {
  String paymentGateway;
  String transactionStatus;
  String paidCurrencyValue;
  String error;

  InvoiceTransactionsData(
      {required this.paidCurrencyValue,
      required this.paymentGateway,
      required this.transactionStatus,
      required this.error});

  factory InvoiceTransactionsData.fromJson(Map<String, dynamic> json) {
    return InvoiceTransactionsData(
      transactionStatus: json['TransactionStatus'],
      paidCurrencyValue: json['PaidCurrencyValue'],
      paymentGateway: json['PaymentGateway'],
      error: json['Error'],
    );
  }
}
