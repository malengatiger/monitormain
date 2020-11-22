import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/ui/project_list/project_list_main.dart';
import 'package:page_transition/page_transition.dart';

class DashboardMobile extends StatefulWidget {
  final User user;
  DashboardMobile({Key key, this.user}) : super(key: key);

  @override
  _DashboardMobileState createState() => _DashboardMobileState();
}

class _DashboardMobileState extends State<DashboardMobile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  var isBusy = false;
  var _projects = List<Project>();
  var _users = List<User>();
  var _photos = List<Photo>();
  var _videos = List<Video>();

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _refresh();
  }

  void _refresh() async {
    pp('_DashboardMobileState: 🎽 🎽 🎽 Refresh data ...');
    setState(() {
      isBusy = false;
    });
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
          title: Text(widget.user == null ? '' : widget.user.name),
        ),
        body: isBusy
            ? Center(
                child: Container(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                    backgroundColor: Colors.teal,
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
                                  Text(
                                    '${_projects.length}',
                                    style: Styles.blackBoldLarge,
                                  ),
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
                                  Text(
                                    '${_users.length}',
                                    style: Styles.blackBoldLarge,
                                  ),
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
                                Text(
                                  '${_photos.length}',
                                  style: Styles.blackBoldLarge,
                                ),
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
                                Text(
                                  '${_videos.length}',
                                  style: Styles.blackBoldLarge,
                                ),
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

  void _navigateToUserList() {
    // Navigator.push(
    //     context,
    //     PageTransition(
    //         type: PageTransitionType.scale,
    //         alignment: Alignment.topLeft,
    //         duration: Duration(seconds: 1),
    //         child: UserListMain()));
  }

  void _navigateToProjectList() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: ProjectListMain(ORG_ADMINISTRATOR)));
  }
}
