import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitormain/ui/dashboard/dashboard_main.dart';
import 'package:monitormain/ui/setup/signin_main.dart';
import 'package:monitormain/ui/setup/signup_mobile.dart';
import 'package:page_transition/page_transition.dart';

class IntroMobile extends StatefulWidget {
  final User? user;
  IntroMobile({Key? key, this.user}) : super(key: key);
  @override
  _IntroMobileState createState() => _IntroMobileState();
}

class _IntroMobileState extends State<IntroMobile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  User? user;

  var lorem =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ac sagittis lectus. Aliquam dictum elementum massa, '
      'eget mollis elit rhoncus ut.';

  var mList = <PageViewModel>[];
  void _buildPages(BuildContext context) {
    var page1 = PageViewModel(
      titleWidget: Text(
        "Welcome to The Digital Monitor",
        style: TextStyle(
            fontSize: Styles.medium, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
      ),
      bodyWidget: Text(
        "$lorem",
        style: Styles.blackSmall,
      ),
      image: Image.asset(
        "assets/intro/img1.jpeg",
        fit: BoxFit.cover,
      ),
    );
    var page2 = PageViewModel(
      titleWidget: Text(
        "Field Monitors are people too",
        style: TextStyle(
            fontSize: Styles.medium, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
      ),
      bodyWidget: Text(
        "$lorem",
        style: Styles.blackSmall,
      ),
      image: Image.asset("assets/intro/img2.jpeg", fit: BoxFit.cover),
    );
    var page3 = PageViewModel(
      titleWidget: Text(
        "Start using The Digital Monitor",
        style: TextStyle(
            fontSize: Styles.medium, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
      ),
      bodyWidget: Text(
        "$lorem",
        style: Styles.blackSmall,
      ),
      image: Image.asset("assets/intro/img3.jpg", fit: BoxFit.cover),
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
            'Digital Monitor',
            style: Styles.whiteSmall,
          ),

          bottom: PreferredSize(
            child: Column(
              children: [
                user == null
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
                    : Text(
                        user!.name!,
                        style: Styles.blackBoldMedium,
                      ),
                SizedBox(
                  height: 24,
                )
              ],
            ),
            preferredSize: Size.fromHeight(60),
          ),
        ),
        backgroundColor: Colors.brown[100],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              IntroductionScreen(
                pages: mList,
                globalBackgroundColor: Colors.amber[50],
                showNextButton: true,
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
                          color: Colors.blue,
                          fontWeight: FontWeight.w900, fontSize: 16
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
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDashboard(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: DashboardMain(user: widget.user)));
  }

  void _navigateToSignUp() async {
    var result = await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: SignupMobile()));
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
