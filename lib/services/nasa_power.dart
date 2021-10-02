import 'dart:convert';
import 'package:http/http.dart';

class RequestNASAPower {
  String community = 're';
  String format = 'json';
  String header = 'false';

  Future<Map> getDailyData({
    required String start,
    required String end,
    required double latitude,
    required double longitude,
    required String params,
  }) async {

    Uri url = Uri.https(
        'power.larc.nasa.gov',
        '/api/temporal/daily/point',
        {
          'start': start,
          'end': end,
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          'community': community,
          'parameters': params,
          'format': format,
          'header': header
        }
    );

    Response rawData = await get(url);

    Map parameters = jsonDecode(rawData.body)['properties']['parameter'];

    return parameters;
  }
}
