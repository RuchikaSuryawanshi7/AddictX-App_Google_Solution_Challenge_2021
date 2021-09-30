import 'package:addictx/pages/leaderboard.dart';
import 'package:addictx/pages/addictXWatch.dart';
import 'package:addictx/pages/contests.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContestHome extends StatefulWidget {

  @override
  _ContestHomeState createState() => _ContestHomeState();
}

class _ContestHomeState extends State<ContestHome> {
  int currentIndex=0;
  PageController pageController=PageController();

  @override
  void dispose()
  {
    pageController?.dispose();
    super.dispose();
  }

  onTapChangePage(int pageIndex) async
  {
    setState(() {
      currentIndex=pageIndex;
    });
    pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 400), curve: Curves.linear);
  }

  whenPageChanges(int pageIndex)
  {
    currentIndex=pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        children: [
          Contests(),
          AddictXWatch(),
          LeaderBoard(),
        ],
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedColor: Color(0xff9ad0e5),
        unSelectedColor: Colors.black,
        currentIndex: currentIndex,
        backgroundColor: const Color(0xfff0f0f0),
        strokeColor: Color(0xff9ad0e5),
        onTap: onTapChangePage,
        items: [
          CustomNavigationBarItem(icon: Icon(Icons.home)),
          CustomNavigationBarItem(icon: Icon(FontAwesomeIcons.dumbbell)),
          CustomNavigationBarItem(icon: Icon(Icons.leaderboard_outlined)),
        ],
      ),
    );
  }
}
