import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'schedule/schedule_widget.dart';
import 'calendar/calendar_widget.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final List<String> _titles = ["Agendarme", "Agenda"];

  late int _currentIndex;
  late bool _isOpen;
  PageController _pageViewController = PageController(initialPage: 0);
  late List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _isOpen = false;
    _tabs = [
      ScheduleWidget(),
      CalendarWidget(),
    ];
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double screenHeight(BuildContext context,
      {double dividedBy = 1, double reducedBy = 0.0}) {
    return (screenSize(context).height - reducedBy) / dividedBy;
  }

  double screenWidth(BuildContext context,
      {double dividedBy = 1, double reducedBy = 0.0}) {
    return (screenSize(context).width - reducedBy) / dividedBy;
  }

  double screenHeightExcludingToolbar(BuildContext context,
      {double dividedBy = 1}) {
    return screenHeight(context,
        dividedBy: dividedBy, reducedBy: kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      height: screenHeight(context),
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return _buildWeb(context);
        } else {
          return _buildMobile(context);
        }
      }),
    );
  }

  Widget _buildWeb(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            appBar: AppBar(
              title: Text(_titles[_currentIndex]),
              centerTitle: false,
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    _isOpen = !_isOpen;
                  });
                },
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                icon: Icon(Icons.menu),
              ),
            ),
            body: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Material(
                  elevation: 1,
                  child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: _isOpen ? 240.0 : 70.0,
                      alignment: AlignmentDirectional.topStart,
                      child: ListView(children: [
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          leading: Icon(Icons.sports_tennis),
                          title: Text(
                            'Agendarme',
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                          ),
                          onTap: () => {
                            setState(() {
                              _currentIndex = 0;
                            }),
                            _pageViewController.jumpToPage(0),
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.calendar_today),
                          title: Text(
                            'Agenda',
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                          ),
                          onTap: () => {
                            setState(() {
                              _currentIndex = 1;
                            }),
                            _pageViewController.jumpToPage(1),
                          },
                        ),
                      ])),
                ),
                Expanded(
                    child: Container(
                  alignment: AlignmentDirectional.topCenter,
                  child: PageView(
                    physics: new NeverScrollableScrollPhysics(),
                    controller: _pageViewController,
                    children: _tabs,
                    onPageChanged: (index) {
                      _onPageChanged(index);
                    },
                  ),
                ))
              ],
            )),
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: FittedBox(
            fit: BoxFit.contain,
            child: Container(
              height: screenHeight(context),
              width: screenWidth(context),
              constraints: BoxConstraints(minWidth: 360, minHeight: 230),
              child: Scaffold(
                appBar: AppBar(
                  title: Text(_titles[_currentIndex]),
                ),
                body: PageView(
                  controller: _pageViewController,
                  children: _tabs,
                  onPageChanged: (index) {
                    _onPageChanged(index);
                  },
                ),
                bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: Colors.blue[200],
                  selectedItemColor: Colors.blue[700],
                  unselectedItemColor: Colors.white,
                  onTap: (index) {
                    _pageViewController.animateToPage(index,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.bounceOut);
                  },
                  currentIndex: _currentIndex,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.sports_tennis),
                      label: _titles[0],
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today),
                      label: _titles[1],
                    ),
                  ],
                ),
              ),
            )));
  }

  Future<bool> _onBackPressed() {
    if (_currentIndex == 1) {
      _onTabTapped(0);
      return Future.value(false);
    }
    return Future.value(true);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageViewController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    });
  }
}
