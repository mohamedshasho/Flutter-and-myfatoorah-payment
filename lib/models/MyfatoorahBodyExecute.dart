class MyfatoorahBodyExecute {
  final int paymentMethodId;
  final String customerName;
  String NotificationOption = "ALL";
  // ALL send the invoice by both Email and SMS
  // EML send the invoice by email only
  // SMS send the invoice by SMS
  final String customerMobile;
  final String customerEmail;
  final double invoiceValue;
  final String displayCurrencyIso;
  final String callBackUrl =
      "https://yoursite.com/done"; // url when success payment
  final String errorUrl =
      "https://yoursite.com/error"; // url when field payment

  MyfatoorahBodyExecute(
      {required this.paymentMethodId,
      required this.customerName,
      required this.customerMobile,
      required this.customerEmail,
      required this.invoiceValue,
      required this.displayCurrencyIso});
}
