class DataExecute {
  int invoiceId;
  String paymentURL;
  DataExecute({required this.invoiceId, required this.paymentURL});

  factory DataExecute.fromJson(Map<String, dynamic> json) {
    return DataExecute(
      invoiceId: json['InvoiceId'],
      paymentURL: json['PaymentURL'],
    );
  }
}
