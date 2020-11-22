import 'package:flutter/material.dart';
import 'package:monitormain/ui/setup/signup_desktop.dart';
import 'package:monitormain/ui/setup/signup_mobile.dart';
import 'package:monitormain/ui/setup/signup_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignupMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: SignupMobile(),
      tablet: SignupTablet(),
      desktop: SignupDesktop(),
    );
  }
}
