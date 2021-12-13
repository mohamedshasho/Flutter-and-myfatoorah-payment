class CardDirect {
  String number;
  String? name;
  String expiryMonth;
  String expiryYear;
  String securityCode;

  CardDirect(
      {required this.number,
      required this.expiryMonth,
      required this.expiryYear,
      required this.securityCode});
}
