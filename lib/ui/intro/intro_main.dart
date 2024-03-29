import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitormain/ui/dashboard/dashboard_main.dart';
import 'package:monitormain/ui/intro/intro_mobile.dart';
import 'package:monitormain/ui/intro/intro_tablet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_builder/responsive_builder.dart';

class IntroMain extends StatefulWidget {
  final User? user;
  IntroMain({Key? key,  this.user}) : super(key: key);

  @override
  _IntroMainState createState() => _IntroMainState();
}

/// Main Widget that manages a responsive layout for intro pages
class _IntroMainState extends State<IntroMain> {
  var isBusy = true;
  User? user;
  @override
  void initState() {
    super.initState();
    if (widget.user == null) {
      _checkUser();
    } else {
      user = widget.user;
    }
  }

  void _checkUser() async {
    pp('IntroMain: 🎽 🎽 🎽 ....... Checking the user ....');
    setState(() {
      isBusy = true;
    });
    user = await Prefs.getUser();
    if (user != null) {
      pp('IntroMain: 🎽 🎽 🎽 Checking the user:  🎽 User is ${user!.name!}  🎽');
      Navigator.pop(context);
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.topLeft,
              duration: Duration(seconds: 1),
              child: DashboardMain(user: user!)));
    } else {
      pp('IntroMain: 🎽 🎽 🎽 Checking the user:  🎽 User is NULL');
    }
    setState(() {
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isBusy
        ? SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text('Loading User ..', style: Styles.whiteSmall),
              ),
              body: Center(
                child: Container(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          )
        : ScreenTypeLayout(
            mobile: IntroMobile(user: user),
            tablet: IntroTablet(user: user),
            desktop: IntroTablet(user: user),
          );
  }
}
