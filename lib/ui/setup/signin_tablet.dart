import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:monitorlibrary/auth/app_auth.dart';
import 'package:monitorlibrary/data/user.dart' as ar;
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/snack.dart';
import 'package:monitormain/ui/dashboard/dashboard_main.dart';
import 'package:page_transition/page_transition.dart';

class SigninTablet extends StatefulWidget {
  @override
  _SigninTabletState createState() => _SigninTabletState();
}

class _SigninTabletState extends State<SigninTablet>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isBusy = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(
          'Digital Monitor Platform',
          style: Styles.whiteSmall,
        ),
        backgroundColor: Colors.brown[400],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Column(
            children: [
              Text("Organization Administrator", style: Styles.whiteBoldMedium),
              SizedBox(
                height: 24,
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.brown[100],
      body: isBusy
          ? Center(
              child: Container(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 24,
                  backgroundColor: Colors.teal[800],
                ),
              ),
            )
          : ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            'Sign in',
                            style: Styles.blackBoldLarge,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          TextField(
                            onChanged: _onEmailChanged,
                            keyboardType: TextInputType.emailAddress,
                            controller: emailCntr,
                            decoration: InputDecoration(
                              hintText: 'Enter  email address',
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          TextField(
                            onChanged: _onPasswordChanged,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            controller: pswdCntr,
                            decoration: InputDecoration(
                              hintText: 'Enter password',
                            ),
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          RaisedButton(
                            onPressed: _signIn,
                            color: Colors.pink[700],
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                'Submit Sign in credentials',
                                style: Styles.whiteSmall,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  TextEditingController emailCntr = TextEditingController();
  TextEditingController pswdCntr = TextEditingController();

  @override
  initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _checkStatus();
  }

  void _checkStatus() async {
    await DotEnv().load('.env');
    var status = DotEnv().env['status'];
    pp('🥦🥦 Checking app status ..... 🥦🥦 $status 🌸 🌸 🌸');
    if (status == 'dev') {
      emailCntr.text = 'fanyana@orga.com';
      pswdCntr.text = 'pass123';
    }
    setState(() {});
  }

  String email = '', password = '';
  void _onEmailChanged(String value) {
    email = value;
    pp(email);
  }

  void _signIn() async {
    email = emailCntr.text;
    password = pswdCntr.text;
    if (email.isEmpty || password.isEmpty) {
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: _key,
          message: "Credentials missing or invalid",
          actionLabel: 'Error');
      return;
    }
    setState(() {
      isBusy = true;
    });
    try {
      var user = await AppAuth.signIn(email, password, ORG_ADMINISTRATOR);
      Navigator.pop(context, user);
      _navigateToDashboard(user);
    } catch (e) {
      setState(() {
        isBusy = false;
      });
      print(e);
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: _key, message: 'Sign In Failed: $e');
    }
  }

  void _navigateToDashboard(ar.User user) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: DashboardMain(user: user)));
  }

  void _onPasswordChanged(String value) {
    password = value;
    pp(password);
  }
}
