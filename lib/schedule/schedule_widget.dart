import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:mysportiesf/main.dart';
import 'package:provider/provider.dart';

class ActivitySelectedItem {
  String asset;
  String title;

  ActivitySelectedItem(this.asset, this.title);
}

class ScheduleWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScheduleWidgetState();
  }

  ScheduleWidget();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _ciFocus = FocusNode();
  final FocusNode _btnFocus = FocusNode();

  late ActivityStore activityStoreGlobal;

  final List<ActivitySelectedItem> _activities = [
    ActivitySelectedItem("aerobica", "Aeróbica"),
    ActivitySelectedItem("basquetbol", "Básquetbol"),
    ActivitySelectedItem("futbol", "Fútbol"),
    ActivitySelectedItem("hockey", "Hockey"),
    ActivitySelectedItem("karate", "Karate"),
    ActivitySelectedItem("musculacion", "Musculación"),
    ActivitySelectedItem("natacion", "Natación"),
    ActivitySelectedItem("pilates", "Pilates"),
    ActivitySelectedItem("spinning", "Spinning"),
    ActivitySelectedItem("tenis", "Tenis"),
    ActivitySelectedItem("voleibol", "Voleibol"),
  ];

  _ScheduleWidgetState();

  late String? _nameInput;
  late String? _ciInput;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  late ActivitySelectedItem? _activity;

  @override
  void initState() {
    _nameInput = null;
    _ciInput = null;
    _activity = null;
    super.initState();
    unfocusAll();
  }

  @override
  void dispose() {
    unfocusAll();
    super.dispose();
  }

  void resetState() {
    unfocusAll();
    setState(() {
      _formKey.currentState?.reset();
      _nameInput = null;
      _ciInput = null;
      _activity = null;
    });
  }

  void unfocusAll() {
    _nameFocus.unfocus();
    _ciFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityStore>(
      builder: (context, activityStore, constraints) {
        activityStoreGlobal = activityStore;
        return _activity == null
            ? Container(
                alignment: AlignmentDirectional.topCenter,
                child: SingleChildScrollView(
                    child: Container(
                        alignment: AlignmentDirectional.topCenter,
                        constraints: BoxConstraints(maxWidth: 1280),
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(children: [
                          SizedBox(height: 15),
                          Text(
                            'Seleccione una actividad',
                            style: new TextStyle(
                                fontSize: 40.0, color: Colors.blue[700]),
                          ),
                          SizedBox(height: 15),
                          Wrap(children: [
                            for (var i = 0; i < _activities.length; i++)
                              _buildCard(context, i)
                          ])
                        ]))))
            : Container(
                alignment: AlignmentDirectional.topCenter,
                child: SingleChildScrollView(
                    child: Container(
                  alignment: AlignmentDirectional.topCenter,
                  constraints: BoxConstraints(maxWidth: 600),
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: _buildContent(context),
                )));
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(children: [
        Text(
          'Ingrese sus datos',
          style: new TextStyle(fontSize: 40.0, color: Colors.blue[700]),
        ),
        SizedBox(height: 20),
        _buildForm(context),
      ]),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 24),
          TextFormField(
              focusNode: _nameFocus,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _nameFocus, _ciFocus);
              },
              keyboardType: TextInputType.name,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: [
                LengthLimitingTextInputFormatter(26),
                FilteringTextInputFormatter.allow(
                    RegExp("^[ña-zÑA-Z][ña-zÑA-Z ]*")),
                FilteringTextInputFormatter.singleLineFormatter,
              ],
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14.5, horizontal: 10.0),
                filled: false,
                labelText: 'Ingrese su nombre (solo letras)',
              ),
              validator: (value) {
                if (value!.isEmpty || value.length < 4) {
                  return 'El nombre es requerido';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _nameInput = value;
                });
              }),
          SizedBox(height: 24),
          TextFormField(
              focusNode: _ciFocus,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _nameFocus, _ciFocus);
              },
              keyboardType: TextInputType.name,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: [
                LengthLimitingTextInputFormatter(26),
                FilteringTextInputFormatter.allow(RegExp('^[0-9]*\$')),
                FilteringTextInputFormatter.singleLineFormatter,
              ],
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14.5, horizontal: 10.0),
                filled: false,
                labelText: 'Ingrese su CI sin puntos ni guíon',
              ),
              validator: (value) {
                if (value!.isEmpty || value.length < 7 || value.length > 8) {
                  return 'La cédula es requerida';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _ciInput = value;
                });
              }),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text('FECHA'),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _selectedTime24Hour(context),
            child: Text('HORA'),
          ),
          SizedBox(height: 24),
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  focusNode: _btnFocus,
                  onPressed: () async {
                    // Validate will return true if the form is valid, or false if the form is invalid.
                    if (_formKey.currentState!.validate()) {
                      // Process data.
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Material(
                              type: MaterialType.transparency,
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 80.0,
                                      height: 80.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 7.0,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Procesando...',
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                          fontSize: 40.0,
                                          color: Colors.blue[700]),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                      await _delayTask();
                      Navigator.pop(context);
                      activityStoreGlobal.addActivity(new ActivityItem(
                          _activity!.asset,
                          _activity!.title,
                          "25/08/2021 22:00"));
                      setState(() {
                        _activity = null;
                      });
                    }
                  },
                  child: Text(
                    'AGENDAR',
                    style: new TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ]),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectedTime24Hour(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 47),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  Future<bool> _delayTask() async {
    //replace the below line of code with your login request
    await new Future.delayed(const Duration(milliseconds: 2000));
    return true;
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget _buildCard(BuildContext context, int index) {
    return Container(
        constraints: BoxConstraints(minWidth: 100, maxWidth: 400),
        margin: EdgeInsets.all(5),
        child: Card(
          child: InkWell(
            onTap: () {
              setState(() {
                _activity = _activities[index];
              });
            },
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCardMedia(context, index),
                  _buildCardTitle(context, index),
                ]),
          ),
        ));
  }

  Widget _buildCardMedia(BuildContext context, int index) {
    return Container(
        child: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(5),
              topLeft: Radius.circular(5),
            ),
            child: Image.asset(
              'assets/images/' + _activities[index].asset + '.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            )));
  }

  Widget _buildCardTitle(BuildContext context, int index) {
    return Container(
      height: 40,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Text('${_activities[index].title}',
          style: Theme.of(context).textTheme.headline6),
    );
  }
}
