import 'package:flutter/material.dart';
import 'package:jour/Database.dart';
import 'package:jour/settings_form.dart';
import 'package:jour/user.dart';
import 'package:jour/work.dart';
import 'package:provider/provider.dart';
import 'workdetails.dart';
import 'auth.dart';
import 'package:jour/LoginPage.dart';
import 'package:table_calendar/table_calendar.dart';

class DetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<userData>(context);
    if (user == null) {
      return LoginPage();
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'avenir'),
        home: detailscard(),
      );
    }
  }
}

class detailscard extends StatefulWidget {
  @override
  _cardState createState() => _cardState();
}

class _cardState extends State<detailscard> {
  final Authservice _auth = Authservice();
  String filterType = "today";
  DateTime today = new DateTime.now();
  String taskPop = "close";
  var monthNames = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEPT",
    "OCT",
    "NOV",
    "DEC"
  ];
  CalendarController ctrlr = new CalendarController();
  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<details>>.value(
      value: DatabaseService().Notes,
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  backgroundColor: Color(0xff292e4e),
                  //elevation: 0,
                  title: Text(
                    "JOUR",
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    FlatButton.icon(
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      label: Text(
                        'logout',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        await _auth.signOut();
                      },
                    ),
                  ],
                ),
                Container(
                  height: 70,
                  color: Colors.blueAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              changeFilter("today");
                            },
                            child: Text(
                              "Today",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 4,
                            width: 120,
                            color: (filterType == "today")
                                ? Colors.white
                                : Colors.transparent,
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              changeFilter("monthly");
                            },
                            child: Text(
                              "Monthly",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 4,
                            width: 120,
                            color: (filterType == "monthly")
                                ? Colors.white
                                : Colors.transparent,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                (filterType == "monthly")
                    ? TableCalendar(
                        calendarController: ctrlr,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        initialCalendarFormat: CalendarFormat.week,
                      )
                    : Container(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Today ${monthNames[today.month - 1]}, ${today.day}/${today.year}",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        workList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 90,
                      width: MediaQuery.of(context).size.width,
                      color: Color(0xff292e4e),
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 80,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 25,
                    left: 0,
                    right: 0,
                    // child: InkWell(
                    //   onTap: openTaskPop,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Colors.lightBlueAccent, Colors.blueAccent],
                          ),
                          shape: BoxShape.circle),
                      child: Center(
                        child: FlatButton(
                          onPressed: () => {
                            _showSettingsPanel(),
                            //do something
                          },
                          child: new Text(
                            '+',
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ),
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

  changeFilter(String filter) {
    filterType = filter;
    setState(() {});
  }

  void openDetailscard() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => detailscard()));
  }
}
