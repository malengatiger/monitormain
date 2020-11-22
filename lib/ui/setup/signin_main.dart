import 'package:flutter/material.dart';
import 'package:monitormain/ui/setup/signin_desktop.dart';
import 'package:monitormain/ui/setup/signin_mobile.dart';
import 'package:monitormain/ui/setup/signin_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SigninMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: SigninMobile(),
      tablet: SigninTablet(),
      desktop: SigninDesktop(),
    );
  }
}
