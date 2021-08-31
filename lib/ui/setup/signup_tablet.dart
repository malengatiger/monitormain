import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/auth/app_auth.dart';
import 'package:monitorlibrary/data/country.dart';
import 'package:monitorlibrary/data/organization.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/snack.dart';
import 'package:monitorlibrary/ui/credit_card/credit_card_handler.dart';
import 'package:monitormain/ui/dashboard/dashboard_main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uuid/uuid.dart';

class SignUpTablet extends StatefulWidget {
  @override
  _SignUpTabletState createState() => _SignUpTabletState();
}

class _SignUpTabletState extends State<SignUpTablet>
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

  var _formState = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();

  var adminController = TextEditingController();
  var adminEmailController = TextEditingController();
  var adminCellphoneController = TextEditingController();
  var adminPasswordController = TextEditingController();

  var isBusy = false;
  var _key = GlobalKey<ScaffoldState>();
  void _submit() async {
    if (_formState.currentState!.validate()) {
      pp('🎽 🎽 🎽 Start submission of new Org and Admin......');
      setState(() {
        isBusy = true;
      });
      try {
        User admin = await _createAdministrator();
        await _createOrganization(admin);
        setState(() {
          isBusy = false;
          showCreditCard = true;
        });
        _navigateToCreditCard();
      } catch (e) {
        setState(() {
          isBusy = false;
        });
        AppSnackbar.showErrorSnackbar(
            scaffoldKey: _key,
            message: "Submission failed: $e",
            actionLabel: '');
      }
    }
  }

  bool showCreditCard = false;
  void _navigateToDashboard(User admin) {
    Navigator.pop(context);
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: DashboardMain(user: admin)));
  }

  void _navigateToCreditCard() async {
    var admin = await Prefs.getUser();
    var result = await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: CreditCardHandlerMain(user: admin!)));

    if (result != null) {
      pp('SignUpTablet:  😡 😡 😡 Credit card processing not quite done yet!  😡 😡 😡');
    }
    _navigateToDashboard(admin);
  }

  Future<User> _createAdministrator() async {
    var uuid = Uuid();
    var admin = User(
        name: adminController.text,
        email: adminEmailController.text,
        cellphone: adminCellphoneController.text,
        created: DateTime.now().toIso8601String(),
        userType: ORG_ADMINISTRATOR,
        organizationName: nameController.text,
        organizationId: uuid.v4(),
        userId: uuid.v4());

    //todo - change pass123 to a uuid string
    var mUser = await AppAuth.createUser(
        user: admin, password: "pass123", isLocalAdmin: true);
    prettyPrint(mUser.toJson(),
        '🥬 🥬 🥬 SignUpMobile:_createAdministrator  🍐  🍐  🍐 RESULT: Administrator auth record created on Firebase');
    return admin;
  }

  Future<Organization> _createOrganization(User admin) async {
    Country? country = await Prefs.getCountry();
    var org = Organization(
        name: nameController.text,
        countryId: country == null ? 'tbd' : country.countryId,
        countryName: country == null ? 'tbd' : country.name,
        email: emailController.text,
        organizationId: admin.organizationId,
        created: DateTime.now().toIso8601String());

    var resultOrg = await DataAPI.addOrganization(org);
    prettyPrint(resultOrg.toJson(),
        '🥬 🥬 🥬 SignUpMobile:_createOrganization  🍐  🍐  🍐 RESULT: Organization ');
    return resultOrg;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text('Digital Monitor Sign Up', style: Styles.whiteSmall),
          actions: [
            showCreditCard
                ? IconButton(
                    icon: Icon(Icons.credit_card),
                    onPressed: _navigateToCreditCard,
                  )
                : Container(),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Please provide the data below and create both an Organization and the first Administrator',
                    style: Styles.whiteSmall,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.brown[600],
        body: Container(
          width: 200,
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Card(
                  elevation: 4,
                  child: Form(
                    key: _formState,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: nameController,
                            decoration: InputDecoration(
                                hintText: 'Enter Organization Name',
                                labelText: 'Organization Name',
                                labelStyle: Styles.blackSmall),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Organization Name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration: InputDecoration(
                                hintText: 'Enter Organization Email',
                                labelText: 'Organization Email',
                                labelStyle: Styles.blackSmall),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Organization Email';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: adminController,
                            decoration: InputDecoration(
                                hintText: 'Enter Organization Administrator',
                                labelText: 'Organization Administrator',
                                labelStyle: Styles.blackSmall),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Administrator name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: adminEmailController,
                            decoration: InputDecoration(
                                hintText: 'Enter Administrator Email',
                                labelText: 'Administrator Email',
                                labelStyle: Styles.blackSmall),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Administrator email';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: adminCellphoneController,
                            decoration: InputDecoration(
                                hintText: 'Enter Administrator Cellphone',
                                labelText: 'Administrator Cellphone',
                                labelStyle: Styles.blackSmall),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Administrator cellphone';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 28,
                          ),
                          isBusy
                              ? Container(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 8,
                                    backgroundColor: Colors.black,
                                  ),
                                )
                              : RaisedButton(
                                  elevation: 4,
                                  color: Theme.of(context).primaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 28.0,
                                        right: 28,
                                        top: 12,
                                        bottom: 12),
                                    child: Text(
                                      'Submit',
                                      style: Styles.whiteSmall,
                                    ),
                                  ),
                                  onPressed: _submit),
                          SizedBox(
                            height: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
