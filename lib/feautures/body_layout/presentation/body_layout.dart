// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:secure_evoting_app/feautures/election/presentation/election.dart';
import 'package:secure_evoting_app/feautures/election_result/presentation/election_result.dart';
import 'package:secure_evoting_app/feautures/home/presentaion/home.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import 'package:secure_evoting_app/feautures/settings/presentation/setting.dart';
import 'package:secure_evoting_app/shared/widget/custom_icon_icons.dart';

class BodyLayoutWidget extends StatefulWidget {
  const BodyLayoutWidget({super.key});

  @override
  State<BodyLayoutWidget> createState() => _BodyLayoutWidgetState();
}

class _BodyLayoutWidgetState extends State<BodyLayoutWidget>
    with TickerProviderStateMixin {
  late MotionTabBarController _motionTabBarController;
  final List<String> _tabLabels = ["Home", "Vote", "Result", "Settings"];
  
  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: _tabLabels.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _motionTabBarController,
        children: <Widget>[
          HomeWidget(),
          ElectionScreen(),
          ElectionResultScreen(),
          SettingScreenWidget(),
        ],
      ),
      bottomNavigationBar: MotionTabBar(
        tabBarColor: Theme.of(context).colorScheme.background,
        textStyle: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Theme.of(context).colorScheme.secondary,
        ),
        tabSelectedColor: Colors.blueAccent,
        controller: _motionTabBarController,
        tabSize: 50.0,
        tabBarHeight: 60.0,
        tabIconSelectedSize: 20.0,
        initialSelectedTab: _tabLabels[0],
        labels: _tabLabels,
        icons: const [
          Icons.home,
          CustomIcon.voting_box,
          CustomIcon.vote_yes,
          Icons.settings,
        ],
        tabIconColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Theme.of(context).colorScheme.secondary,
        onTabItemSelected: (int value) {
          setState(() {
            _motionTabBarController.index = value;
          });
        },
      ),
    );
  }
}
