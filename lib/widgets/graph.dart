import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_sunshine/services/nasa_power.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Graph extends StatefulWidget {
  final SharedPreferences sharedPrefs;
  final String title;
  final String unit;
  final String start;
  final String end;
  final List<String> params;
  final List<String> names;

  const Graph(this.sharedPrefs, {
    Key? key,
    required this.title,
    required this.start,
    required this.end,
    required this.unit,
    required this.params,
    required this.names,
  }) : super(key: key);

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {

  RequestNASAPower request = RequestNASAPower();
  final TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
  final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
    enablePinching: true,
    enablePanning: true,
  );

  List<ChartSeries> data = [];
  Map parametersData = {};
  bool toggleSpline = false;
  bool loading = false;
  double longitude = double.negativeInfinity;
  double latitude = double.negativeInfinity;
  String start = '';
  String end = '';
  int temporal = 2;
  int graphIndex = 0;
  int paramsLen = 0;

  final List<Color> colors = [
    Colors.deepOrange,
    Colors.blue,
    Colors.amber,
    Colors.pink,
    Colors.green,
    Colors.brown,
    Colors.grey,
    Colors.yellowAccent,
  ];

  void collectData() async {
    setState(() {
      longitude = widget.sharedPrefs.getDouble('long') ?? longitude;
      latitude = widget.sharedPrefs.getDouble('lat') ?? latitude;
      graphIndex = widget.sharedPrefs.getInt('graph') ?? graphIndex;
      start = widget.start;
      end = widget.end;
      paramsLen = widget.params.length;
    });
    parametersData = await request.getDailyData(
      start: widget.start,
      end: widget.end,
      latitude: latitude,
      longitude: longitude,
      params: widget.params.join(','),
    );
    processData();
    setState(() {loading = false;});
  }

  DateTime string2datetime(String date) {
    return DateTime(
      int.parse(date.substring(0, 4)),
      int.parse(date.substring(4, 6)),
      int.parse(date.substring(6, 8)),
    );
  }

  void processData() {
    setState(() {
      data = [];
      temporal = widget.sharedPrefs.getInt('temporal') ?? temporal;

      for (int i = 0; i < parametersData.length; i++) {
        String key = parametersData.keys.toList()[i];

        List<String> subKeys = parametersData[key].keys.toList();

        List<List> rawPoints = [];
        List<List> points = [];

        for (int j = 0; j < parametersData[key].length; j += 1) {
          rawPoints.add([
            string2datetime(subKeys[j]),
            parametersData[key][subKeys[j]] == -999
                ? null : parametersData[key][subKeys[j]]
          ]);
        }

        switch (temporal) {
          case (0): {
            List months = rawPoints.map((e) => DateTime(e[0].year, e[0].month)).toSet().toList();
            for (int j = 0; j < months.length; j++) {
              List values = rawPoints.where(
                  (e) => e[0].year == months[j].year && e[0].month == months[j].month && e[1] != null
              ).map((e) => e[1]).toList();
              points.add([
                months[j],
                values.isNotEmpty ? values.reduce((a, b) => a + b) / values.length : null
              ]);
            }
          } break;
          case (1): {
            for (int j = 0; j < (rawPoints.length / 7).floor() * 7; j += 7) {
              List weekData = rawPoints.sublist(j, j + 7);
              if (weekData.every((e) => e == null)) {
                points.add([weekData[j][0], null]);
                break;
              }
              int trueLen = weekData.where((e) => e != null).length;

              double avg = trueLen != 0
                  ? weekData.map((e) => e[1] ?? 0).toList().reduce((a, b) => a + b) / trueLen : null;
              points.add([rawPoints[j][0], avg == 0 ? null : avg]);
            }
          } break;
          case (2): {
            points = rawPoints;
          } break;
        }

        data.add(AreaSeries<List, DateTime>(
          dataSource: points,
          name: widget.names[i],
          xValueMapper: (List e, _) => e[0],
          yValueMapper: (List e, _) => e[1],
          color: colors[i],
          borderColor: colors[i],
          borderWidth: 5,
          borderDrawMode: BorderDrawMode.top,
          opacity: 0.2,
        ));
      }
    });
  }

  @override
  void initState() {
    setState(() {
      loading = true;
      temporal = widget.sharedPrefs.getInt('temporal') ?? 2;
    });
    collectData();
    super.initState();
  }

  Widget sfGraph() {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(),
      primaryYAxis: NumericAxis(
          title: AxisTitle(
              text: () {
                String unit = widget.unit;
                if (unit == '') return '';
                if (unit[unit.length - 1] == '/') {
                  int temporal = widget.sharedPrefs.getInt('temporal') ?? 2;
                  switch (temporal) {
                    case (0): {return unit + 'month';}
                    case (1): {return unit + 'week';}
                    case (2): {return unit + 'day';}
                  }
                }
                return unit;
              }(),
              alignment: ChartAlignment.far
          )
      ),
      series: data,
      tooltipBehavior: _tooltipBehavior,
      zoomPanBehavior: _zoomPanBehavior,
      legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          borderColor: const Color(0xff7c8083),
          borderWidth: 1,
          overflowMode: LegendItemOverflowMode.wrap,
          textStyle: const TextStyle(
              color: Color(0xff7c8083),
              fontSize: 15,
              fontFamily: 'Times New Roman'
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (longitude != (widget.sharedPrefs.getDouble('long') ?? longitude)
        || latitude != (widget.sharedPrefs.getDouble('lat') ?? latitude)
        || graphIndex != (widget.sharedPrefs.getInt('graph') ?? graphIndex)
        || start != widget.start
        || end != widget.end
        || paramsLen != widget.params.length) {
      loading = true;
      collectData();
    }
    if (temporal != (widget.sharedPrefs.getInt('temporal'))) {
      processData();
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/graph', arguments: sfGraph());
              },
              icon: const Icon(Icons.zoom_out_map),
              iconSize: 30,
            ),
            Expanded(
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                softWrap: true,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
            ),
          ],
        ),
        Stack(
          children: [
            sfGraph(),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Visibility(
                  child: defaultTargetPlatform == TargetPlatform.iOS
                      ? const CupertinoActivityIndicator()
                      : const CircularProgressIndicator(
                    color: Color(0xff7c8083),
                    strokeWidth: 8,
                  ),
                  visible: loading,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
