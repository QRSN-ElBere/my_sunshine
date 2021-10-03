import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PlacesProvider {
  final client = Client();
  final String sessionToken;

  PlacesProvider(this.sessionToken);

  static const String androidKey = 'AIzaSyARgQR41ZNal9ENZVCdlUvu1CQjDSIGUOg';
  static const String iosKey = 'AIzaSyBmA12_-r9g1gJb9KXExfWUGCGVz8UQLsI';
  static String apiKey = defaultTargetPlatform == TargetPlatform.android ? androidKey : iosKey;

  Future<List<String>> getPlaces(String input, String language) async {
    Uri url = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      {
        'input': input,
        'types': 'address',
        'language': language,
        'key': apiKey,
        'sessiontoken': sessionToken
      }
    );

    Response response = await client.get(url);
    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      if (result['status'] == 'OK') {
        return result['predictions']
            .map<String>((p) => (p['description'] as String))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }

  }

}