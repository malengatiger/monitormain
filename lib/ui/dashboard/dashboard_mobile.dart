import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/bloc/fcm_bloc.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/bloc/theme_bloc.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart' as mon;
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/ui/credit_card/credit_card_handler.dart';
import 'package:monitorlibrary/ui/media/list/media_list_main.dart';
import 'package:monitorlibrary/ui/project_list/project_list_main.dart';
import 'package:monitorlibrary/users/list/user_list_main.dart';
import 'package:monitormain/ui/intro/intro_main.dart';
import 'package:monitormain/ui/intro/intro_mobile.dart';
import 'package:page_transition/page_transition.dart';
import 'package:universal_platform/universal_platform.dart';

class DashboardMobile extends StatefulWidget {
  final mon.User user;
  DashboardMobile({Key? key, required this.user}) : super(key: key);

  @override
  _DashboardMobileState createState() => _DashboardMobileState();
}

class _DashboardMobileState extends State<DashboardMobile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var isBusy = false;
  var _projects = <Project>[];
  var _users = <mon.User>[];
  var _photos = <Photo>[];
  var _videos = <Video>[];
  mon.User? _user;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _getAdmin();
    _setItems();
    _listen();
  }

  void _getAdmin() async {
    _user = await Prefs.getUser();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var items = <BottomNavigationBarItem>[];
  void _setItems() {
    items
        .add(BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'));
    items.add(
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Projects'));
    // items.add(
    //     BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Reports'));
  }

  void _refresh(bool forceRefresh) async {
    setState(() {
      isBusy = true;
    });
    await monitorBloc.refreshOrgDashboardData(forceRefresh: forceRefresh);
    setState(() {
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(
                  Icons.credit_card,
                  size: 20,
                ),
                onPressed: _navigateToCreditCard),
            IconButton(
                icon: Icon(
                  Icons.info_outline,
                  size: 20,
                ),
                onPressed: _navigateToIntro),
            IconButton(
              icon: Icon(
                Icons.settings,
                size: 20,
              ),
              onPressed: () {
                themeBloc.changeToRandomTheme();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                size: 20,
              ),
              onPressed: () {
                _refresh(true);
              },
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(120),
            child: Column(
              children: [
                Text(
                  widget.user.organizationName!,
                  style: Styles.blackBoldMedium,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  widget.user.name!,
                  style: Styles.whiteBoldMedium,
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  'Team Administrator',
                  style: Styles.blackTiny,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.brown[100],
        bottomNavigationBar: BottomNavigationBar(
          items: items,
          onTap: _handleBottomNav,
        ),
        body: isBusy
            ? Center(
                child: Container(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    backgroundColor: Colors.yellow,
                  ),
                ),
              )
            : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: [
                        Container(
                          child: GestureDetector(
                            onTap: _navigateToProjectList,
                            child: Card(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 48,
                                  ),
                                  StreamBuilder<List<Project>>(
                                      stream: monitorBloc.projectStream,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData)
                                          _projects = snapshot.data!;
                                        return Text(
                                          '${_projects.length}',
                                          style: Styles.blackBoldLarge,
                                        );
                                      }),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Projects',
                                    style: Styles.greyLabelSmall,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: _navigateToUserList,
                            child: Card(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 48,
                                  ),
                                  StreamBuilder<List<User>>(
                                      stream: monitorBloc.usersStream,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData)
                                          _users = snapshot.data!;
                                        return Text(
                                          '${_users.length}',
                                          style: Styles.blackBoldLarge,
                                        );
                                      }),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Users',
                                    style: Styles.greyLabelSmall,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Card(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 48,
                                ),
                                StreamBuilder<List<Photo>>(
                                    stream: monitorBloc.photoStream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData)
                                        _photos = snapshot.data!;
                                      return Text(
                                        '${_photos.length}',
                                        style: Styles.blackBoldLarge,
                                      );
                                    }),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Photos',
                                  style: Styles.greyLabelSmall,
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Card(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 48,
                                ),
                                StreamBuilder<List<Video>>(
                                    stream: monitorBloc.videoStream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData)
                                        _videos = snapshot.data!;
                                      return Text(
                                        '${_videos.length}',
                                        style: Styles.blackBoldLarge,
                                      );
                                    }),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Videos',
                                  style: Styles.greyLabelSmall,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _handleBottomNav(int value) {
    switch (value) {
      case 0:
        pp(' 🔆🔆🔆 Navigate to MonitorList');
        _navigateToUserList();
        break;
      case 1:
        pp(' 🔆🔆🔆 Navigate to ProjectList');
        _navigateToProjectList();
        break;
      case 2:
        pp(' 🔆🔆🔆 Navigate to MediaList');
        _navigateToMediaList();
        break;
    }
  }

  void _navigateToMediaList() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: MediaListMain(null)));
  }

  void _navigateToUserList() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: UserListMain()));
  }

  void _navigateToProjectList() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: ProjectListMain(widget.user)));
  }

  void _navigateToIntro() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: IntroMobile(
              user: widget.user,
            )));
  }

  void _navigateToCreditCard() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: CreditCardHandlerMain(
              user: widget.user,
            )));
  }

  void _listen() async {
    var android = UniversalPlatform.isAndroid;
    var ios = UniversalPlatform.isIOS;

    if (android || ios) {
      pp('DashboardMobile: 🍎 🍎 _listen to FCM message streams ... 🍎 🍎');
      fcmBloc.projectStream.listen((Project project) async {
        if (mounted) {
          pp('DashboardMobile: 🍎 🍎 showProjectSnackbar: ${project.name} ... 🍎 🍎');
          _projects = await monitorBloc.getOrganizationProjects(
              organizationId: _user!.organizationId!, forceRefresh: false);
          setState(() {});
          // SpecialSnack.showProjectSnackbar(
          //     scaffoldKey: _key,
          //     textColor: Colors.white,
          //     backgroundColor: Theme.of(context).primaryColor,
          //     project: project,
          //     listener: this);
        }
      });
      fcmBloc.userStream.listen((User user) async {
        if (mounted) {
          pp('DashboardMobile: 🍎 🍎 showUserSnackbar: ${user.name} ... 🍎 🍎');
          _users = await monitorBloc.getOrganizationUsers(
              organizationId: _user!.organizationId!, forceRefresh: false);
          setState(() {});
          // SpecialSnack.showUserSnackbar(
          //     scaffoldKey: _key, user: user, listener: this);
        }
      });
      fcmBloc.photoStream.listen((Photo photo) async {
        if (mounted) {
          pp('DashboardMobile: 🍎 🍎 showPhotoSnackbar: ${photo.userName} ... 🍎 🍎');
          _photos = await monitorBloc.getOrganizationPhotos(
              organizationId: _user!.organizationId!, forceRefresh: false);
          setState(() {});
          // SpecialSnack.showPhotoSnackbar(
          //     scaffoldKey: _key, photo: photo, listener: this);
        }
      });
      fcmBloc.videoStream.listen((Video video) async {
        if (mounted) {
          pp('DashboardMobile: 🍎 🍎 showVideoSnackbar: ${video.userName} ... 🍎 🍎');
          _videos = await monitorBloc.getOrganizationVideos(
              organizationId: _user!.organizationId!, forceRefresh: false);
          // SpecialSnack.showVideoSnackbar(
          //     scaffoldKey: _key, video: video, listener: this);
        }
      });
      fcmBloc.messageStream.listen((mon.OrgMessage message) {
        if (mounted) {
          pp('DashboardMobile: 🍎 🍎 showMessageSnackbar: ${message.message} ... 🍎 🍎');

          // SpecialSnack.showMessageSnackbar(
          //     scaffoldKey: _key, message: message, listener: this);
        }
      });
    } else {
      pp('App is running on the Web 👿 👿 👿  firebase messaging is OFF 👿 👿 👿');
    }
  }

  var _key = GlobalKey<ScaffoldState>();
  static const BLUE =
      '🔵 🔵 🔵 DashboardMain:  🦠  🦠  🦠 FCM message arrived:  🦠 ';


}
