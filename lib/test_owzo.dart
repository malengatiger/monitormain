import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:monitorlibrary/data/ozow_payment_request.dart';
import 'package:monitorlibrary/functions.dart';

class TestOwzo extends StatefulWidget {
  @override
  _TestOwzoState createState() => _TestOwzoState();
}

class _TestOwzoState extends State<TestOwzo>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    sendPayment();
  }

  String result;
  bool busy;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void sendPayment() async {
    setState(() {
      busy = true;
    });
    var req = OzowPaymentRequest(
        siteCode: DotEnv.env['ozowSiteCode'],
        countryCode: DotEnv.env['countryCode'],
        transactionReference: 'SUPERBOWL 2021',
        currencyCode: DotEnv.env['currencyCode'],
        bankReference: 'BANKREF1',
        errorUrl: DotEnv.env['errorUrl'],
        isTest: true,
        hashCheck: null,
        notifyUrl: DotEnv.env['notifyUrl'],
        successUrl: DotEnv.env['successUrl'],
        amount: 95.99,
        cancelUrl: DotEnv.env['cancelUrl'],
        customer: 'Customer One');

    req.hashCheck = OzowPaymentRequest.generateOzowHash(req);
    pp('🌺 🌺 🌺 🌺 PaymentRequest JSON: ${req.toJson()}');
    result = await OzowPaymentRequest.postPaymentRequest(req);
    pp('🌺 🌺 🌺 🌺  Result: $result');
    setState(() {
      busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Ozow Test'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: Column(
            children: [
              Text(
                'Banging on Ozow',
                style: Styles.whiteBoldMedium,
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
      body: busy
          ? Center(
              child: Container(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 16,
                  backgroundColor: Colors.red,
                ),
              ),
            )
          : Container(
              child: Text('$result'),
            ),
    ));
  }
}
