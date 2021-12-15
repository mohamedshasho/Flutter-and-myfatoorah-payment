import 'package:flutter/material.dart';

import 'MyFatoorah_Service.dart';
import 'card_dialoge.dart';
import 'models/CardDirect.dart';
import 'models/MyfatoorahBodyExecute.dart';
import 'models/MyfatoorahResponseDirect.dart';
import 'models/MyfatoorahResponseExecute.dart';
import 'models/MyfatoorahResponseInitiate.dart';
import 'models/MyfatoorahResponseStatus.dart';
import 'myfatoorah_select_initiate.dart';
import 'web_view.dart';

class Home extends StatelessWidget {
  static const String apiTest = "https://apitest.myfatoorah.com/";
  static const String tokenTest =
      "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL";
  bool progress = false;
  static const List currencyCode = [
    'KWD',
    'SAR',
    'BHD',
    'AED',
    'QAR',
    'OMR',
    'JOD',
    'EGP'
  ];
  double totalPrice = 5.0;
  late MyFatoorahService _myFatoorahService;
  late MyfatoorahResponseInitiate _responseInitiate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: !progress
              ? ElevatedButton(
                  child: Text("send"),
                  onPressed: () {
                    myfatoorahPayment(context);
                  },
                )
              : CircularProgressIndicator()),
    );
  }

  myfatoorahPayment(BuildContext context) async {
    try {
      String payment_mode = 'test';
      String currency_code = currencyCode[0];
      String _kEYTest = tokenTest;
      // String _kEYlive = tokenTest;
      _myFatoorahService = MyFatoorahService(
          paymentMode: payment_mode,
          currencyIso: currency_code,
          test: _kEYTest,
          secret: '',
          invoiceAmount: totalPrice);
      _responseInitiate = await _myFatoorahService.postInitiate();

      if (_responseInitiate.isSuccess!) {
        int? selectPaymentId = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyfatoorahSelectInitiate(_responseInitiate),
          ),
        );
        String mobile = '';
        String email = '';
        String username = '';

        if (selectPaymentId != -1 && selectPaymentId != null) {
          print('selectPaymentId: ' + selectPaymentId.toString());
          MyfatoorahBodyExecute bodyExecute = MyfatoorahBodyExecute(
              paymentMethodId: selectPaymentId,
              customerName: username,
              customerEmail: email,
              customerMobile: mobile,
              displayCurrencyIso: currency_code,
              invoiceValue: totalPrice);
          MyfatoorahResponseExecute responseExecute =
              await _myFatoorahService.postExecute(bodyExecute);

          if (responseExecute.isSuccess) {
            String? myFatoorahPayId =
                responseExecute.data!.invoiceId.toString();
            String? patmentUri = responseExecute.data!.paymentURL;
            String paymentDirect = 'card';
            //paymentDirect card or token
            await showDialog(
                context: context,
                builder: (ctx) {
                  return CardDialog();
                }).then((valueFromDialog) async {
              if (valueFromDialog != null) {
                CardDirect _cardDirect = valueFromDialog;
                _cardDirect.name = username;

                MyfatoorahResponseDirect responseDirect =
                    await _myFatoorahService.postDirect(
                  paymentType: paymentDirect,
                  cartDirect: _cardDirect,
                  paymentDirectUri: patmentUri,
                );

                if (responseDirect.isSuccess &&
                    responseDirect.message == null) {
                  print(responseDirect.data!.status);
                  if (responseDirect.data!.status == 'Success') {
                    await showDialog(
                        context: context,
                        builder: (ctx) {
                          return WebViewInApp(responseDirect.data!.paymentURL!);
                        }).then((value) async {
                      MyfatoorahResponseStatus status = await _myFatoorahService
                          .getPayStatus(myFatoorahPayId);
                      if (status.isSuccess) {
                        if (status.invoiceTransactions!.transactionStatus ==
                            'InProgress') {
                          // setSnackbar(
                          //     getTranslated(context, 'Failed'), _scaffoldKey);
                          // checkoutState(() {
                          //   _isProgress = false;
                          // });
                        } else if (status
                                .invoiceTransactions!.transactionStatus ==
                            'Succss') {
                          //   placeOrder(status.data.invoiceStatus);
                        } else if (status
                                .invoiceTransactions!.transactionStatus ==
                            'Failed') {
                          // setSnackbar(
                          //     getTranslated(context, 'Failed'), _scaffoldKey);
                          // checkoutState(() {
                          //   _isProgress = false;
                          // });
                        }
                        print('status: ' + status.data!.invoiceStatus);
                        print('transactionStatus: ' +
                            status.invoiceTransactions!.transactionStatus);
                      } else {
                        // setSnackbar(
                        //     status.message != null
                        //         ? status.message
                        //         : status.validationErrors,
                        //     _checkscaffoldKey);
                        // setState(() {
                        //   _isProgress = false;
                        // });
                      }
                    });
                    // }
                  }
                } else {
                  // checkoutState(() {
                  //   _isProgress = false;
                  // });
                  // setSnackbar(responseDirect.message, _checkscaffoldKey);
                  // if (responseDirect.data != null)
                  //   print('error cart direct:' +
                  //       responseDirect.data.errorMessage);
                }
              } else {
                // checkoutState(() {
                //   _isProgress = false;
                // });
              }
            });
          } else {
            // setSnackbar(responseExecute.validationErrors, _checkscaffoldKey);
            // checkoutState(() {
            //   _isProgress = false;
            // });
          }
        } else {
          // checkoutState(() {
          //   _isProgress = false;
          // });
        }
      } else {
        // setSnackbar(_responseInitiate.validationErrors, _checkscaffoldKey);
        // checkoutState(() {
        //   _isProgress = false;
        // });
      }
    } catch (e) {
      print(e);
    }
  }
}
