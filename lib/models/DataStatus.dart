class DataStatus {
  int invoiceId;
  String invoiceStatus;
  String expiryDate;
  double invoiceValue;
  String customerName;
  String customerMobile;
  String customerEmail;
  String invoiceDisplayValue;

  DataStatus(
      {required this.invoiceId,
      required this.invoiceStatus,
      required this.expiryDate,
      required this.invoiceValue,
      required this.customerName,
      required this.customerMobile,
      required this.customerEmail,
      required this.invoiceDisplayValue});

  factory DataStatus.fromJson(Map<String, dynamic> json) {
    return DataStatus(
      invoiceId: json['InvoiceId'],
      invoiceValue: json['InvoiceValue'],
      invoiceStatus: json['InvoiceStatus'],
      invoiceDisplayValue: json['InvoiceDisplayValue'],
      customerName: json['CustomerName'],
      customerMobile: json['CustomerMobile'],
      customerEmail: json['CustomerEmail'],
      expiryDate: json['ExpiryDate'],
    );
  }
}
