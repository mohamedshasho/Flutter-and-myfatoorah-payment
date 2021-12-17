import 'dart:convert';
import 'dart:io';

import 'models/CardDirect.dart';
import 'models/MyfatoorahBodyExecute.dart';
import 'models/MyfatoorahResponseDirect.dart';
import 'models/MyfatoorahResponseExecute.dart';
import 'models/MyfatoorahResponseInitiate.dart';
import 'models/MyfatoorahResponseStatus.dart';

import 'package:http/http.dart';

class MyFatoorahService {
  static String myFatoorahApiLive = 'https://api.myfatoorah.com/v2/';
  static String myFatoorahApiTest = 'https://apitest.myfatoorah.com/v2/';
  String paymentMode;
  static String paymentInitiate = 'InitiatePayment';
  static String paymentExecute = 'ExecutePayment';
  static String getPaymentStatus = 'GetPaymentStatus';
  // paymentDirect = '';
  String secret;
  String test;
  String currencyIso;
  double invoiceAmount;

  static final json = new ContentType("application", "json", charset: "utf-8");

  late MyfatoorahResponseInitiate responseInitiate;
  late MyfatoorahResponseExecute responseExecute;
  late MyfatoorahResponseDirect responseDirect;

  MyFatoorahService(
      {required this.paymentMode,
      required this.test,
      required this.secret,
      required this.currencyIso,
      required this.invoiceAmount});

  Future<MyfatoorahResponseInitiate> postInitiate() async {
    responseInitiate = MyfatoorahResponseInitiate();
    var _bodyInitiate = {
      "InvoiceAmount": invoiceAmount,
      "CurrencyIso": currencyIso
    };
    try {
      if (paymentMode == 'test') {
        print(paymentMode + ' Initiate');
        Map<String, String> _headers = {
          'Authorization': "Bearer " + test,
          'Content-Type': 'application/json',
        };
        Response response = await post(
          Uri.parse(myFatoorahApiTest + paymentInitiate),
          headers: _headers,
          body: jsonEncode(_bodyInitiate),
        );
        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          responseInitiate.isSuccess = data['IsSuccess'];
          var paymentMethods = data['Data'];
          if (responseInitiate.isSuccess! && data.isNotEmpty) {
            var paymentMethodsResponse = paymentMethods['PaymentMethods'];
            for (var payment in paymentMethodsResponse) {
              DataInitiate dataInitiate =
                  DataInitiate.fromJson(payment as Map<String, dynamic>);
              responseInitiate.data.add(dataInitiate);
            }
          }
          responseInitiate.validationErrors = data['ValidationErrors'] == null
              ? 'Validation Success'
              : data['ValidationErrors'];
          return responseInitiate;
        } else {
          responseInitiate.isSuccess = false;
          responseInitiate.validationErrors = 'Initiate Error';
          return responseInitiate;
        }
      } else if (paymentMode == 'live') {
        print(paymentMode);
        Map<String, String> _headers = {
          'Authorization': "Bearer " + secret,
          'Content-Type': 'application/json',
        };
        Response response = await post(
          Uri.parse(myFatoorahApiLive + paymentInitiate),
          headers: _headers,
          body: jsonEncode(_bodyInitiate),
        );
        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          responseInitiate.isSuccess = data['IsSuccess'];
          var paymentMethods = data['Data'];
          if (responseInitiate.isSuccess! && data.isNotEmpty) {
            var paymentMethodsResponse = paymentMethods['PaymentMethods'];
            for (var payment in paymentMethodsResponse) {
              DataInitiate dataInitiate =
                  DataInitiate.fromJson(payment as Map<String, dynamic>);
              responseInitiate.data.add(dataInitiate);
            }
          }
          responseInitiate.validationErrors = data['ValidationErrors'] == null
              ? 'Validation Success'
              : data['ValidationErrors'];
          return responseInitiate;
        } else {
          responseInitiate.isSuccess = false;
          responseInitiate.validationErrors = 'Initiate Error';
          return responseInitiate;
        }
      } else {
        throw 'Error Payment mode';
      }
    } catch (e) {
      throw 'Error Initiate: ' + e.toString();
    }
  }

  Future<MyfatoorahResponseExecute> postExecute(
      MyfatoorahBodyExecute bodyExecute) async {
    /// only 9 PaymentMethodId for test
    var _body = {
      'PaymentMethodId':
          paymentMode == "test" ? 9 : bodyExecute.paymentMethodId,
      "CustomerName": bodyExecute.customerName, //optional
      "DisplayCurrencyIso": bodyExecute.displayCurrencyIso,
      "MobileCountryCode": "965", //optional
      "CustomerMobile": bodyExecute.customerMobile, //optional
      "CustomerEmail": bodyExecute.customerEmail, //optional
      "InvoiceValue": bodyExecute.invoiceValue,
      'CallBackUrl': bodyExecute.callBackUrl, //optional
      'ErrorUrl': bodyExecute.errorUrl, //optional
      'Language': 'ar', //optional
    };
    try {
      if (paymentMode == 'test') {
        Map<String, String> _headers = {
          'Authorization': "Bearer " + test,
          'Content-Type': 'application/json',
        };
        Response response = await post(
          Uri.parse(myFatoorahApiTest + paymentExecute),
          headers: _headers,
          body: jsonEncode(_body),
        );
        print(response.statusCode);
        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          if (data['IsSuccess']) {
            print(data.toString());
            responseExecute = MyfatoorahResponseExecute.fromJson(data);
            return responseExecute;
          } else {
            responseExecute = MyfatoorahResponseExecute(
                isSuccess: false, validationErrors: data['ValidationErrors']);
            return responseExecute;
          }
        } else {
          responseExecute = MyfatoorahResponseExecute(
              isSuccess: false, validationErrors: 'Execute Error');
          return responseExecute;
        }
      } else if (paymentMode == 'live') {
        Map<String, String> _headers = {
          'Authorization': "Bearer " + secret,
          'Content-Type': 'application/json',
        };
        Response response = await post(
          Uri.parse(myFatoorahApiLive + paymentExecute),
          headers: _headers,
          body: jsonEncode(_body),
        );
        print('body: ' + _body.toString());
        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          if (data['IsSuccess']) {
            print('data execute: ' + data.toString());
            responseExecute = MyfatoorahResponseExecute.fromJson(data);
            return responseExecute;
          } else {
            responseExecute = MyfatoorahResponseExecute(
                isSuccess: false, validationErrors: data['ValidationErrors']);
            return responseExecute;
          }
        } else {
          responseExecute = MyfatoorahResponseExecute(
              isSuccess: false, validationErrors: 'Execute Error');
          return responseExecute;
        }
      } else {
        throw 'Error payment mode';
      }
    } catch (e) {
      throw 'error Execute: ' + e.toString();
    }
  }

  Future<MyfatoorahResponseDirect> postDirect(
      {required String paymentType,
      required CardDirect cartDirect,
      required String paymentDirectUri}) async {
    print('paymentType: ' + paymentType);
    Map<String, dynamic> bodyDirect = {
      'paymentType': paymentType,
      'saveToken': false,
      'Bypass3DS': false,
      'card': {
        'Number': cartDirect.number!.trim(),
        'expiryMonth': cartDirect.expiryMonth!.trim(),
        'expiryYear': cartDirect.expiryYear!.trim(),
        'securityCode': cartDirect.securityCode!.trim(),
        'CardHolderName': cartDirect.name ?? ''
      }
    };
    try {
      if (paymentMode == 'test') {
        print(paymentMode + ' Direct');
        Map<String, String> _headers = {
          'Authorization': "Bearer " + test,
          'Content-Type': "application/json"
        };

        Response response = await post(
          Uri.parse(paymentDirectUri),
          headers: _headers,
          body: jsonEncode(bodyDirect),
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          print(data.toString());
          if (data['IsSuccess']) {
            responseDirect = MyfatoorahResponseDirect.fromjson(data);
            return responseDirect;
          } else {
            responseDirect = MyfatoorahResponseDirect(
              isSuccess: false,
              message: data['Message'],
            );
            return responseDirect;
          }
        } else {
          responseDirect = MyfatoorahResponseDirect(
              isSuccess: false, message: 'Direct Error validation');
          return responseDirect;
        }
      } else if (paymentMode == 'live') {
        print(paymentMode + ' Direct');
        Map<String, String> _headerSecret = {
          'Authorization': "Bearer " + secret,
          'Content-Type': "application/json"
        };
        print('uri ' + paymentDirectUri);
        print('bodyDirect:  ' + bodyDirect.toString());
        Response response = await post(
          Uri.parse(paymentDirectUri),
          headers: _headerSecret,
          body: jsonEncode(bodyDirect),
        );

        print('response.statusCode: ' + response.statusCode.toString());
        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          // print('data: ' + data.toString());
          if (data['IsSuccess']) {
            responseDirect = MyfatoorahResponseDirect.fromjson(data);
            return responseDirect;
          } else {
            responseDirect = MyfatoorahResponseDirect(
              isSuccess: false,
              message: data['Message'],
            );
            return responseDirect;
          }
        } else {
          responseDirect = MyfatoorahResponseDirect(
              isSuccess: false, message: 'Direct Error validation');
          return responseDirect;
        }
      } else {
        throw 'Error payment mode';
      }
    } catch (e) {
      throw 'error direct: ' + e.toString();
    }
  }

  Future<MyfatoorahResponseStatus> getPayStatus(String key) async {
    MyfatoorahResponseStatus status;
    var _body = {'Key': key, 'KeyType': 'InvoiceId'};
    try {
      if (paymentMode == 'test') {
        print(paymentMode + ' PaymentStatus');
        Map<String, String> _headers = {
          'Authorization': "Bearer " + test,
          'Content-Type': 'application/json',
        };
        Response response = await post(
          Uri.parse(myFatoorahApiTest + getPaymentStatus),
          headers: _headers,
          body: jsonEncode(_body),
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          print(data.toString());
          if (data['IsSuccess']) {
            status = MyfatoorahResponseStatus.fromJson(data);
            return status;
          } else {
            status = MyfatoorahResponseStatus(
                isSuccess: false,
                validationErrors: data['ValidationErrors'],
                message: data['Message']);
            return status;
          }
        } else {
          status = MyfatoorahResponseStatus(
              isSuccess: false,
              validationErrors: 'Status Error validation',
              message: 'Status Error validation');
          return status;
        }
      } else if (paymentMode == 'live') {
        Map<String, String> _headers = {
          'Authorization': "Bearer " + secret,
          'Content-Type': 'application/json',
        };
        Response response = await post(
          Uri.parse(myFatoorahApiLive + getPaymentStatus),
          headers: _headers,
          body: jsonEncode(_body),
        );
        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          // print(data.toString());
          if (data['IsSuccess']) {
            status = MyfatoorahResponseStatus.fromJson(data);
            return status;
          } else {
            status = MyfatoorahResponseStatus(
                isSuccess: false,
                validationErrors: data['ValidationErrors'],
                message: data['Message']);
            return status;
          }
        } else {
          status = MyfatoorahResponseStatus(
              isSuccess: false,
              validationErrors: 'Status Error validation',
              message: 'Status Error validation');
          return status;
        }
      } else {
        throw 'Error payment mode';
      }
    } catch (e) {
      throw 'error PayStatus: ' + e.toString();
    }
  }
}
