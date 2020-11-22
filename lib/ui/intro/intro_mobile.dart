import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitormain/ui/dashboard/dashboard_main.dart';
import 'package:monitormain/ui/setup/signin_main.dart';
import 'package:monitormain/ui/setup/signup_main.dart';
import 'package:page_transition/page_transition.dart';

class IntroMobile extends StatefulWidget {
  final User user;
  IntroMobile({Key key, this.user}) : super(key: key);
  @override
  _IntroMobileState createState() => _IntroMobileState();
}

class _IntroMobileState extends State<IntroMobile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  var page1 = PageViewModel(
    title: "Welcome to The Visual Monitor",
    body: "This app will help you monitor progress on any type of project ...",
    image: Image.asset(
      "assets/intro/img1.jpeg",
      fit: BoxFit.cover,
    ),
  );
  var page2 = PageViewModel(
    title: "Field Monitors are people too",
    body:
        "Here you can write the description of the page, to explain something...",
    image: Image.asset("assets/intro/img2.jpeg", fit: BoxFit.cover),
  );
  var page3 = PageViewModel(
    title: "Title of third page",
    body:
        "Here you can write the description of the page, to explain something...",
    image: Image.asset("assets/intro/img3.jpg", fit: BoxFit.cover),
  );

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'The Visual Monitor',
            style: Styles.whiteSmall,
          ),
          bottom: PreferredSize(
            child: Column(
              children: [
                widget.user == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            onPressed: _navigateToSignUp,
                            child: Text(
                              'Sign Up',
                              style: Styles.blackBoldSmall,
                            ),
                          ),
                          SizedBox(
                            width: 48,
                          ),
                          FlatButton(
                            onPressed: _navigateToSignIn,
                            child:
                                Text('Sign In', style: Styles.blackBoldSmall),
                          ),
                          SizedBox(
                            width: 24,
                          ),
                        ],
                      )
                    : Text(widget.user.name),
                SizedBox(
                  height: 4,
                )
              ],
            ),
            preferredSize: Size.fromHeight(40),
          ),
        ),
        body: Stack(
          children: [
            IntroductionScreen(
              pages: [page1, page2, page3],
              onDone: () {
                _navigateToDashboard(context);
              },
              onSkip: () {
                _navigateToDashboard(context);
              },
              showSkipButton: true,
              skip: const Icon(Icons.skip_next),
              next: const Icon(Icons.arrow_forward),
              done: widget.user == null
                  ? Container()
                  : const Text("Done",
                      style: TextStyle(fontWeight: FontWeight.w600)),
              dotsDecorator: DotsDecorator(
                  size: const Size.square(10.0),
                  activeSize: const Size(20.0, 10.0),
                  activeColor: Theme.of(context).accentColor,
                  color: Colors.black26,
                  spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0))),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDashboard(BuildContext context) {
    if (widget.user != null) {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.topLeft,
              duration: Duration(seconds: 1),
              child: DashboardMain(user: widget.user)));
    }
  }

  void _navigateToSignUp() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: SignupMain()));
  }

  void _navigateToSignIn() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: SigninMain()));
  }
}
