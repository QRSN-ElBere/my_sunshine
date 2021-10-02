import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:my_sunshine/services/parameters.dart';
import 'package:my_sunshine/widgets/graph.dart';

class Main extends StatefulWidget {

  final Parameters parameters;
  final SharedPreferences sharedPrefs;

  const Main(this.sharedPrefs, this.parameters, {Key? key}) : super(key: key);


  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  String address = '--, ----';
  DateTime start = DateTime.now().subtract(const Duration(days: 30));
  DateTime end = DateTime.now();
  List<bool> activeTemporal = [false, false, false];

  @override
  void initState() {
    setState(() {
      activeTemporal[widget.sharedPrefs.getInt('temporal') ?? 2] = true;
    });
    super.initState();
  }

  String datetime2string(DateTime date) {
    return date.year.toString()
        + date.month.toString().padLeft(2, '0')
        + date.day.toString().padLeft(2, '0');
  }

  void alertUser({required String title, required String message}) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, 'OK!'),
                  child: const Text('OK!')
              )
            ],
          )
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          elevation: 10,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, 'OK!'),
                child: const Text('OK!')
            )
          ],
        ),
      );
    }
  }

  Future<DateTime?> selectDate(BuildContext context, DateTime date) async {
    if (activeTemporal.indexOf(true) == 0) {
      DateTime? picked = await showMonthPicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(DateTime.now().year, DateTime.now().month + 1),
        initialDate: date,
      );
      if (picked != null && picked != date) return picked;
    } else {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2000),
        lastDate: DateTime(DateTime.now().year, DateTime.now().month + 1),
      );
      if (picked != null && picked != date) return picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    int chosenIndex = widget.parameters.chosenIndex;
    address = widget.sharedPrefs.getString('address') ?? address;
    List<List<int>> unitParams = widget.parameters.divideParams(chosenIndex);

    return Container(
      color: const Color(0xff132030),
      child: SafeArea(
        child: Column(
          children: [
            // location
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: RawMaterialButton(
                onPressed: () {Navigator.pushNamed(context, '/maps').then(
                  (value) {
                    address = widget.sharedPrefs.getString('address') ?? address;
                    setState(() {});
                  });},
                elevation: 10,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Color(0xff7c8083), width: 5)
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.rotate(
                          angle: -pi / 6,
                          child: const Icon(
                            Icons.push_pin,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Text(
                          address.split(',')[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25
                          ),
                        )
                      ],
                    ),
                    Text(
                      address.split(',')[1],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Title
            DropdownButton<int>(
              alignment: Alignment.center,
              itemHeight: 75,
              value: chosenIndex,
              iconSize: 40,
              elevation: 10,
              style: const TextStyle(fontSize: 25, fontFamily: 'Times New Roman'),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  widget.sharedPrefs.setInt('graph', newValue);
                  chosenIndex = newValue;
                  widget.parameters.refresh();
                  setState(() {});
                }
              },
              items: widget.parameters.values.map<DropdownMenuItem<int>>(
                      (ParametersGroup group) => DropdownMenuItem(
                      value: widget.parameters.values.indexOf(group),
                      child: Center(child: Text(group.name))
                  )
              ).toList(),
            ),
            // Graphs
            Expanded(
              child: ListView.builder(
                itemCount: unitParams.length + 1,
                cacheExtent: 10000,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // start
                          ElevatedButton(
                              child: Text(start.toString().split(' ')[0]),
                              onPressed: () async {
                                DateTime? date = await selectDate(context, start);
                                if (date == null) return;
                                if (!date.isBefore(end)) {
                                  alertUser(
                                      title: 'Incorrect Timeline!',
                                      message: 'The first date can\'t be after the last date.'
                                  );
                                } else {
                                  int index = activeTemporal.indexOf(true);
                                  int days = end.difference(date).inDays;
                                  if (index == 0 && days <= 3 * 31) {
                                    alertUser(
                                        title: 'Incorrect Timeline!',
                                        message: 'Duration should be more than 3 months with monthly temporal'
                                    );
                                  } else if (index == 1 && days <= 3 * 7) {
                                    alertUser(
                                        title: 'Incorrect Timeline!',
                                        message: 'Duration should be more than 3 weeks with weekly temporal'
                                    );
                                  } else if (index == 2 && days <= 3) {
                                    alertUser(
                                        title: 'Incorrect Timeline!',
                                        message: 'Duration should be more than 3 days with daily temporal'
                                    );
                                  } else {
                                    setState(() {start = date;});
                                  }
                                }
                              }
                          ),
                          // end
                          ElevatedButton(
                              onPressed: () async {
                                DateTime? date = await selectDate(context, end);
                                if (date == null) return;
                                if (!date.isAfter(start)) {
                                  alertUser(
                                      title: 'Incorrect Timeline!',
                                      message: 'The last date can\'t be before the first date.'
                                  );
                                } else {
                                  int index = activeTemporal.indexOf(true);
                                  int days = date.difference(start).inDays;
                                  if (index == 0 && days <= 3 * 31) {
                                    alertUser(
                                        title: 'Incorrect Timeline!',
                                        message: 'Duration should be more than 3 months with monthly temporal'
                                    );
                                  } else if (index == 1 && days <= 3 * 7) {
                                    alertUser(
                                        title: 'Incorrect Timeline!',
                                        message: 'Duration should be more than 3 weeks with weekly temporal'
                                    );
                                  } else if (index == 2 && days <= 3) {
                                    alertUser(
                                        title: 'Incorrect Timeline!',
                                        message: 'Duration should be more than 3 days with daily temporal'
                                    );
                                  } else {
                                    setState(() {end = date;});
                                  }
                                }
                              },
                              child: Text(end.toString().split(' ')[0])
                          )
                        ],
                      ),
                      ToggleButtons(
                        isSelected: activeTemporal,
                        onPressed: (index) {
                          setState(() {
                            activeTemporal = [false, false, false];
                            activeTemporal[index] = true;
                          });
                          widget.sharedPrefs.setInt('temporal', index);
                          int days = end.difference(start).inDays;
                          final scaffold = ScaffoldMessenger.of(context);
                          switch (index) {
                            case (0): {
                              if (days <= 3 * 31) {
                                setState(() {
                                  start = DateTime(end.year, end.month - 4, 1);
                                });
                                scaffold.showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.black,
                                      content: Text(
                                        'first date has been changed to '
                                            + start.toString().split(' ')[0]
                                            + ' for duration purposes',
                                        style: const TextStyle(color: Colors.white),
                                      )
                                  ),
                                );
                              }
                            } break;
                            case (1): {
                              if (days <= 3 * 7) {
                                setState(() {
                                  start = DateTime(end.year, end.month, end.day - 4*7);
                                });
                                scaffold.showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.black,
                                      content: Text(
                                        'first date has been changed to '
                                            + start.toString().split(' ')[0]
                                            + ' for duration purposes',
                                        style: const TextStyle(color: Colors.white),
                                      )
                                  ),
                                );
                              }
                            } break;
                            case (2): {
                              if (days <= 3) {
                                setState(() {
                                  start = DateTime(end.year, end.month, end.day - 4);
                                });
                                scaffold.showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.black,
                                      content: Text(
                                        'first date has been changed to '
                                            + start.toString().split(' ')[0]
                                            + ' for duration purposes',
                                        style: const TextStyle(color: Colors.white),
                                      )
                                  ),
                                );
                              }
                            } break;
                          }
                        },
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('monthly'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('weekly'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('daily'),
                          ),
                        ],
                      ),
                    ]);
                  }
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Graph(
                        widget.sharedPrefs,
                        title: widget.parameters.values[chosenIndex]
                            .params[unitParams[index - 1][0]].title,
                        start: datetime2string(start),
                        end: datetime2string(end),
                        unit: widget.parameters.values[chosenIndex]
                            .params[unitParams[index - 1][0]].unit,
                        params: unitParams[index - 1].map((e) =>
                        widget.parameters.values[chosenIndex].params[e].code
                        ).toList(),
                        names: unitParams[index - 1].map((e) =>
                        widget.parameters.values[chosenIndex].params[e].name
                        ).toList()
                    ),
                  );
                }
              ),
            ),
          ]
        ),
      ),
    );
  }
}
