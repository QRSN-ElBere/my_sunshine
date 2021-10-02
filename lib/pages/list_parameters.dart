import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_sunshine/services/parameters.dart';
import 'package:flutter/material.dart';

class ListParameters extends StatefulWidget {
  final SharedPreferences sharedPrefs;
  final Parameters parameters;

  const ListParameters(this.sharedPrefs, this.parameters, {Key? key})
      : super(key: key);

  @override
  _ListParametersState createState() => _ListParametersState();
}

class _ListParametersState extends State<ListParameters> {

  String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) + newChar + oldString.substring(index + 1);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int i, bool isExpanded) {
        setState(() {
          widget.parameters.values[i].isExpanded = !isExpanded;
        });
      },
      children: widget.parameters.values.map<ExpansionPanel>(
        (ParametersGroup group) {
          return ExpansionPanel(
            backgroundColor: Colors.transparent,
            canTapOnHeader: true,
            headerBuilder: (_, __) =>
                ListTile(
                  leading: Checkbox(
                    value: group.chosen,
                    onChanged: (bool? val) {setState(() {
                      if (val == true) {
                        widget.sharedPrefs.setInt(
                          'graph',
                          widget.parameters.values.indexOf(group)
                        );
                        widget.parameters.refresh();
                      } else if (val == false) {
                        group.chosen = false;
                      }
                    });},
                  ),
                  title: Text(
                    group.name,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times New Roman',
                      fontSize: 25
                    )
                  )
                ),
            body: ExpansionPanelList(
              expansionCallback: (int i, bool isExpanded) {
                setState(() {
                  group.params[i].isExpanded = !isExpanded;
                });
              },
              dividerColor: Colors.black,
              // expandedHeaderPadding: EdgeInsets.all(8),
              children: group.params.map<ExpansionPanel>(
                      (Parameter param) {
                    return ExpansionPanel(
                      backgroundColor: const Color(0xff132030),
                      headerBuilder: (_, __) =>
                          ListTile(
                            leading: Checkbox(
                              value: param.value,
                              onChanged: group.chosen
                              ? (bool? val) {
                                if (val != null) {
                                  setState(() {param.value = val;});
                                  widget.sharedPrefs.setString(
                                    group.name,
                                    replaceCharAt(
                                      group.chosenParams,
                                      group.params.indexOf(param),
                                      val ? '1' : '0'
                                    )
                                  );
                                  group.refresh();
                                }
                              }
                              : null,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            title: Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(param.name)
                            )
                          ),
                      body: Text(param.details),
                      isExpanded: param.isExpanded
                  );
                  }
              ).toList(),
            ),
            isExpanded: group.isExpanded
          );
        }
      ).toList(),
    );
  }
}
