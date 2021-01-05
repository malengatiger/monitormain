import 'package:flutter/material.dart';
import 'package:monitormain/ui/setup/signin_mobile.dart';
import 'package:monitormain/ui/setup/signin_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SigninMain extends StatefulWidget {
  @override
  _SigninMainState createState() => _SigninMainState();
}

class _SigninMainState extends State<SigninMain> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: SigninMobile(),
      tablet: SigninTablet(),
      desktop: SigninTablet(),
    );
  }
}
