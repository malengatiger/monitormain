import 'package:flutter/material.dart';

class OzowPayment extends StatefulWidget {
  @override
  _OzowPaymentState createState() => _OzowPaymentState();
}

class _OzowPaymentState extends State<OzowPayment>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
