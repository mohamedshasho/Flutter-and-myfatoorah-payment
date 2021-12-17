import 'package:flutter/material.dart';

import 'models/CardDirect.dart';

class CardDialog extends StatefulWidget {
  @override
  _CardDialogState createState() => _CardDialogState();
}

class _CardDialogState extends State<CardDialog> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController numberC = TextEditingController();
  TextEditingController monthC = TextEditingController();
  TextEditingController yearC = TextEditingController();
  TextEditingController securityC = TextEditingController();

  CardDirect _cardDirect = CardDirect();

  @override
  void dispose() {
    super.dispose();
    numberC.dispose();
    monthC.dispose();
    yearC.dispose();
    securityC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                    child: Text(
                      'CARD INFO',
                      style: Theme.of(this.context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.lightGreen),
                    )),
                const Divider(color: Colors.black45),
                Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              validator: (val) =>
                                  val!.length != 16 ? 'ERROR CART' : null,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                  hintText: 'cart number',
                                  hintStyle: Theme.of(this.context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        color: Colors.black54,
                                      ),
                                  suffixIcon: Icon(
                                    Icons.credit_card,
                                    size: 20,
                                    color: Colors.white24,
                                  )),
                              controller: numberC,
                              onChanged: (v) => setState(() {
                                _cardDirect.number = v;
                              }),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: Row(
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    validator: (val) =>
                                        val!.length != 2 ? "ERROR MONTH" : null,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      hintText: 'month',
                                      hintStyle: Theme.of(this.context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.normal),
                                    ),
                                    controller: monthC,
                                    onChanged: (v) => setState(() {
                                      _cardDirect.expiryMonth = v;
                                    }),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Flexible(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    validator: (val) =>
                                        val!.length != 2 ? 'ERROR YEAR' : null,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      hintText: 'year',
                                      hintStyle: Theme.of(this.context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.normal),
                                    ),
                                    controller: yearC,
                                    onChanged: (v) => setState(() {
                                      _cardDirect.expiryYear = v;
                                    }),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Flexible(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    validator: (val) => val!.length == 3
                                        ? null
                                        : 'error security',
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: new InputDecoration(
                                      hintText: 'security',
                                      hintStyle: Theme.of(this.context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.normal),
                                    ),
                                    controller: securityC,
                                    onChanged: (v) => setState(() {
                                      _cardDirect.securityCode = v;
                                    }),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ))
              ])),
      actions: <Widget>[
        TextButton(
            child: Text(
              'CANCEL',
              style: Theme.of(this.context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: Colors.black54, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        TextButton(
            child: Text(
              'PAID',
              style: Theme.of(this.context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: Colors.black54, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              final form = _formkey.currentState;
              if (form!.validate()) {
                form.save();
                if (mounted)
                  setState(() {
                    Navigator.pop(context, _cardDirect);
                  });
                // checkNetwork();
              }
            })
      ],
    );
  }
}
