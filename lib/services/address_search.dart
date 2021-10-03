import 'package:flutter/material.dart';
import 'package:my_sunshine/services/places_provider.dart';

class AddressSearch extends SearchDelegate {
  late PlacesProvider provider;

  AddressSearch(String sessionToken) {
    provider = PlacesProvider(sessionToken);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {query = '';},
        tooltip: 'Clear',
        icon: const Icon(Icons.clear)
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        close(context, '');
      },
      tooltip: 'Back',
      icon: const Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future:  query == "" ? null : provider.getPlaces(query, 'en'),
      builder: (context, snapshot) {
        return query == ''
          ? Container(
            padding: const EdgeInsets.all(16),
            child: const Text('Enter the address'),
          )
          : snapshot.data == null
          ? const Text('Loading...')
          : ListView.builder(
            itemCount: (snapshot.data as List).length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text((snapshot.data as List)[index]),
                onTap: () {
                  FocusScope.of(context).unfocus();
                  close(context, (snapshot.data as List)[index]);
                }
              );
            }
          );
      }
    );
  }

}