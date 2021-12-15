import 'package:flutter/material.dart';

import 'models/MyfatoorahResponseInitiate.dart';

class MyfatoorahSelectInitiate extends StatefulWidget {
  final MyfatoorahResponseInitiate responseInitiate;
  const MyfatoorahSelectInitiate(this.responseInitiate);
  @override
  _MyfatoorahSelectInitiateState createState() =>
      _MyfatoorahSelectInitiateState();
}

class _MyfatoorahSelectInitiateState extends State<MyfatoorahSelectInitiate> {
  //List<RadioModel> payModel = [];
  int _value = -1;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var hieght = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    Widget paymentItem(int index) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Radio<int>(
                groupValue: _value,
                value: widget.responseInitiate.data[index]!.paymentMethodId,
                onChanged: (val) {
                  setState(() {
                    _value = val!;
                  });
                },
              ),
              Text(
                widget.responseInitiate.data[index]!.paymentMethodAr,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
              ),
            ],
          ),
          Image.network(
            widget.responseInitiate.data[index]!.imageUrl,
            height: hieght * 0.1,
            width: width * 0.15,
          ),
        ],
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('SELECT PAYMENT'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: widget.responseInitiate.data.length,
              itemBuilder: (ctx, index) {
                // print(widget.responseInitiate.data[index].paymentMethodId);
                // if (widget.responseInitiate.data[index].paymentMethodId == 2 ||
                //     widget.responseInitiate.data[index].paymentMethodId == 6 ||
                //     widget.responseInitiate.data[index].paymentMethodId == 9) {
                return paymentItem(index);
                //  }
                //  return const SizedBox();
              },
            ),
          ),
          ElevatedButton(
            child: Text('Done'),
            onPressed: () {
              if (_value != -1) {
                Navigator.pop(context, _value);
              } else {
                setSnackbar("select payment type", _scaffoldKey);
              }
            },
          ),
        ],
      ),
    );
  }

  setSnackbar(String msg, GlobalKey<ScaffoldState> _scaffoldKey) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      elevation: 1.0,
    ));
  }
}
