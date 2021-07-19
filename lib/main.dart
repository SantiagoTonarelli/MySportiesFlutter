import 'package:flutter/material.dart';
import 'home_widget.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ActivityStore(),
          ),
        ],
        child: MaterialApp(
          title: 'MySporties',
          theme: ThemeData(
              fontFamily: 'Roboto',
              primarySwatch: Colors.blue,
              primaryColor: Colors.blue[500],
              accentColor: Colors.blue[300],
              visualDensity: VisualDensity.adaptivePlatformDensity,
              buttonTheme: ButtonThemeData(
                buttonColor: Colors.blue[700],
                minWidth: 200,
                height: 44,
              )),
          home: Home(),
        ));
  }
}

class ActivityStore extends ChangeNotifier {
  List<ActivityItem> _activities = [];

  ActivitiesStore(List<ActivityItem> initialValue) {
    _activities = initialValue;
  }

  List<ActivityItem> get activities => _activities;

  void addActivity(ActivityItem activity) {
    _activities.add(activity);
    notifyListeners();
  }
}

class ActivityItem {
  String asset;
  String title;
  String date;

  ActivityItem(this.asset, this.title, this.date);
}
