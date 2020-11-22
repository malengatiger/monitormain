import 'package:flutter/material.dart';

class SignupTablet extends StatefulWidget {
  @override
  _SignupTabletState createState() => _SignupTabletState();
}

class _SignupTabletState extends State<SignupTablet>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

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
