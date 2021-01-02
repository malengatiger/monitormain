import 'package:flutter/material.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitormain/ui/dashboard/dashboard_desktop.dart';
import 'package:monitormain/ui/dashboard/dashboard_mobile.dart';
import 'package:monitormain/ui/dashboard/dashboard_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DashboardMain extends StatefulWidget {
  final User user;

  const DashboardMain({Key key, this.user}) : super(key: key);
  @override
  _DashboardMainState createState() => _DashboardMainState();
}

class _DashboardMainState extends State<DashboardMain>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  var isBusy = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _refreshData();
  }

  void _refreshData() async {
    pp('Refresh data ....');
    monitorBloc.refreshDashboardData(forceRefresh: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: DashboardMobile(
        user: widget.user,
      ),
      tablet: DashboardTablet(
        user: widget.user,
      ),
      desktop: DashboardDesktop(
        user: widget.user,
      ),
    );
  }
}
