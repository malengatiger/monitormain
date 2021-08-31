import 'package:flutter/material.dart';

class SignupDesktop extends StatefulWidget {
  @override
  _SignupDesktopState createState() => _SignupDesktopState();
}

class _SignupDesktopState extends State<SignupDesktop>
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
