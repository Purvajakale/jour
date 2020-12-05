import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jour/Database.dart';
import 'package:jour/user.dart';
import 'package:provider/provider.dart';
import 'loading.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'main.dart';

void main() => runApp(new MyApp());

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime currentTime, LocaleType locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> meet = ['official', 'unofficial', 'family', 'health'];
  final List<int> imp = [200, 300, 400, 500, 600, 700];

  //form values
  String _currentwork;
  String _currentname;
  String _currentdescription;
  int _currentimportance = 200;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<userData>(context);
    return StreamBuilder<userStream>(
        stream: DatabaseService(uid: user.uid).UserStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userStream userstream = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: TextFormField(
                      initialValue: userStream().name,
                      validator: (val) =>
                          val.isEmpty ? 'please enter title' : null,
                      onChanged: (val) => setState(() => _currentname = val),
                      decoration: InputDecoration(
                          hintText: "Title", border: InputBorder.none),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          child: TextFormField(
                            initialValue: userStream().name,
                            validator: (val) =>
                                val.isEmpty ? 'please enter description' : null,
                            onChanged: (val) =>
                                setState(() => _currentdescription = val),
                            maxLength: 30,
                            decoration: InputDecoration(
                                hintText: "Description",
                                border: InputBorder.none),
                            style: TextStyle(fontSize: 18),
                          ),
                        ),

                        SizedBox(height: 20.0),

                        //work dropdown
                        DropdownButtonFormField(
                          value: _currentwork ?? userStream().work,
                          items: meet.map((work) {
                            return DropdownMenuItem(
                              value: work,
                              child: Text('$work meeting'),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => _currentwork = val),
                        ),
                        SizedBox(height: 25.0),
                        //importance
                        Container(
                          child: Text('How important is your task?'),
                        ),
                        Slider(
                          value: (_currentimportance ?? userStream().importance)
                              .toDouble(),
                          activeColor: Colors.blueGrey[
                              _currentimportance ?? userStream().importance],
                          inactiveColor: Colors.blueGrey[
                              _currentimportance ?? userStream().importance],
                          min: 200,
                          max: 700,
                          divisions: 5,
                          label: 'Task Priority',
                          onChanged: (val) =>
                              setState(() => _currentimportance = val.round()),
                        ),
                        FlatButton(
                          onPressed: () {
                            DatePicker.showTime12hPicker(context,
                                showTitleActions: true, onChanged: (date) {
                              print('change $date in time zone ' +
                                  date.timeZoneOffset.inHours.toString());
                            }, onConfirm: (date) {
                              print('confirm $date');
                            }, currentTime: DateTime.now());
                          },
                          child: Text(
                            'Select time',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        ButtonTheme(
                          minWidth: 400.0,
                          height: 50.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: Color(0xff292e4e),
                            child: Text(
                              'Add Task',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              print(_currentwork);
                              print(_currentname);
                              print(_currentdescription);
                              print(_currentimportance);
                              if (_formKey.currentState.validate()) {
                                await DatabaseService(uid: user.uid)
                                    .updateUserData(
                                  _currentwork ?? snapshot.data.work,
                                  _currentname ?? snapshot.data.name,
                                  _currentdescription ??
                                      snapshot.data.description,
                                  _currentimportance ??
                                      snapshot.data.importance,
                                );
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}

//username text
// TextFormField(
//   initialValue: userStream().name,
//   validator: (val) =>
//       val.isEmpty ? 'please enter a name' : '',
//   onChanged: (val) =>
//       setState(() => _currentname = val),
// ),
