import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitormain/ui/dashboard/dashboard_main.dart';
import 'package:monitormain/ui/setup/signin_main.dart';
import 'package:monitormain/ui/setup/signup_main.dart';
import 'package:page_transition/page_transition.dart';

class IntroTablet extends StatefulWidget {
  final User user;
  IntroTablet({Key key, this.user}) : super(key: key);
  @override
  _IntroTabletState createState() => _IntroTabletState();
}

class _IntroTabletState extends State<IntroTablet>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  User user;

  var mList = <PageViewModel>[];
  void _buildPages(BuildContext context) {
    var page1 = PageViewModel(
      titleWidget: Text(
        "Welcome to The Digital Monitor Platform",
        style: TextStyle(
            fontSize: Styles.medium, color: Theme.of(context).primaryColor),
      ),
      bodyWidget: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Text(
            "$lorem",
            style: Styles.blackSmall,
          ),
        ),
      ),
      image: Image.asset(
        "assets/web/arch2.jpg",
        fit: BoxFit.cover,
      ),
    );
    var page2 = PageViewModel(
      titleWidget: Text(
        "Field Monitors are people too",
        style: TextStyle(
            fontSize: Styles.medium, color: Theme.of(context).primaryColor),
      ),
      bodyWidget: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Text(
            "$lorem",
            style: Styles.blackSmall,
          ),
        ),
      ),
      image: Image.asset("assets/web/industry.jpg", fit: BoxFit.fill),
    );
    var page3 = PageViewModel(
      titleWidget: Text(
        "Thank you for using The Digital Monitor",
        style: TextStyle(
            fontSize: Styles.medium, color: Theme.of(context).primaryColor),
      ),
      bodyWidget: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Text(
            "$lorem",
            style: Styles.blackSmall,
          ),
        ),
      ),
      image: Image.asset("assets/web/stair.jpg", fit: BoxFit.fill),
    );
    mList.clear();
    setState(() {
      mList.add(page1);
      mList.add(page2);
      mList.add(page3);
    });
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    user = widget.user;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (mList.isEmpty) {
      _buildPages(context);
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'The Digital Monitor Platform',
            style: Styles.whiteSmall,
          ),
          bottom: PreferredSize(
            child: Column(
              children: [
                user == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RaisedButton(
                            elevation: 8,
                            color: Theme.of(context).accentColor,
                            onPressed: _navigateToSignUp,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'If not registered, please Sign Up',
                                style: Styles.whiteBoldSmall,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          RaisedButton(
                            elevation: 4,
                            color: Theme.of(context).primaryColor,
                            onPressed: _navigateToSignIn,
                            child: Text('Sign In', style: Styles.whiteSmall),
                          ),
                          SizedBox(
                            width: 24,
                          ),
                        ],
                      )
                    : Text(
                        user.name,
                        style: Styles.blackBoldSmall,
                      ),
                SizedBox(
                  height: 16,
                )
              ],
            ),
            preferredSize: Size.fromHeight(40),
          ),
        ),
        body: Stack(
          children: [
            IntroductionScreen(
              pages: mList,
              onDone: () {
                _navigateToDashboard(context);
              },
              onSkip: () {
                _navigateToDashboard(context);
              },
              showSkipButton: false,
              skip: const Icon(Icons.skip_next),
              next: const Icon(Icons.arrow_forward),
              done: user == null
                  ? Container()
                  : Text("Done",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      )),
              dotsDecorator: DotsDecorator(
                size: const Size.square(10.0),
                activeSize: const Size(20.0, 10.0),
                activeColor: Theme.of(context).primaryColor,
                color: Colors.black26,
                spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
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

  void _navigateToSignUp() async {
    var result = await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: SignupMain()));
    if (result is User) {
      setState(() {
        user = result;
      });
    }
  }

  void _navigateToSignIn() async {
    var result = await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: SigninMain()));
    if (result is User) {
      setState(() {
        user = result;
      });
    }
  }
}
