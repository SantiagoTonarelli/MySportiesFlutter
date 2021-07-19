import 'package:flutter/material.dart';
import 'package:mysportiesf/main.dart';
import 'package:provider/provider.dart';

class CalendarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarWidgetState();
  }

  CalendarWidget();
}

class _CalendarWidgetState extends State<CalendarWidget> {

  _CalendarWidgetState();

  late ActivityStore activityStoreGlobal;

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityStore>(
      builder: (context, activityStore, constraints) {
        activityStoreGlobal = activityStore;
        return activityStore.activities.length != 0
            ? Container(
                alignment: AlignmentDirectional.topCenter,
                child: SingleChildScrollView(
                    child: Container(
                        alignment: AlignmentDirectional.topCenter,
                        constraints: BoxConstraints(maxWidth: 1280),
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Wrap(children: [
                          for (var i = 0;
                              i < activityStore.activities.length;
                              i++)
                            _buildCard(context, i)
                        ]))))
            : Center(
                child: Text(
                  "No tiene actividades agendadas",
                  textAlign: TextAlign.center,
                  style: new TextStyle(fontSize: 60.0, color: Colors.blue[700]),
                ),
              );
      },
    );
  }

  Widget _buildCard(BuildContext context, int index) {
    return Container(
      constraints: BoxConstraints(minWidth: 100, maxWidth: 400),
      margin: EdgeInsets.all(5),
      child: Card(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _buildCardMedia(context, index),
          _buildCardTitle(context, index),
          _buildCardDate(context, index),
        ]),
      ),
    );
  }

  Widget _buildCardMedia(BuildContext context, int index) {
    return Container(
        child: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(5),
              topLeft: Radius.circular(5),
            ),
            child: Image.asset(
              'assets/images/' + activityStoreGlobal.activities[index].asset + '.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            )));
  }

  Widget _buildCardTitle(BuildContext context, int index) {
    return Container(
      height: 40,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Text('${activityStoreGlobal.activities[index].title}',
          style: Theme.of(context).textTheme.headline6),
    );
  }

  Widget _buildCardDate(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Row(children: [
        Expanded(
            child: Text('${activityStoreGlobal.activities[index].date}',
                style: Theme.of(context).textTheme.bodyText2)),
      ]),
    );
  }
}
