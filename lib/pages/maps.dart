import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class Maps extends StatefulWidget {
  final SharedPreferences sharedPrefs;

  const Maps(this.sharedPrefs, {Key? key}) : super(key: key);

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final MapTileLayerController mapController = MapTileLayerController();
  final TextEditingController textController = TextEditingController();
  final MapZoomPanBehavior _zoomPanBehavior = MapZoomPanBehavior(
    focalLatLng: const MapLatLng(0, 0),
    enablePinching: true,
    maxZoomLevel: 18,
    minZoomLevel: 1,
    enableDoubleTapZooming: true,
  );

  late Position location;
  late MapLatLng markerPosition;
  double defaultZoom = 1;
  double longitude = double.negativeInfinity;
  double latitude = double.negativeInfinity;
  double newLongitude = 0;
  double newLatitude = 0;
  bool pickLocation = false;
  bool autoLocation = false;
  bool searchLocation = false;
  bool markerExist = false;
  bool serviceEnabled = false;
  bool permissionAllowed = true;
  bool drawL2R = true;
  bool drawT2B = true;
  bool welcome = false;
  String address = '';
  final String mapKey = '5xUXohTLGSEuWNFXIeQ5';

  Future<Position> determinePosition() async {

    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('0');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permissionAllowed = false;
        return Future.error('1');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('2');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }
  
  void putMarker() async {
    await Future.delayed(const Duration(milliseconds: 500));
    mapController.insertMarker(0);
  }

  @override
  void initState() {
    setState(() {
      longitude = widget.sharedPrefs.getDouble('long') ?? longitude;
      latitude = widget.sharedPrefs.getDouble('lat') ?? latitude;
      welcome = widget.sharedPrefs.getBool('welcome') ?? welcome;
      newLongitude = longitude;
      newLatitude = latitude;
    });
    _zoomPanBehavior.zoomLevel = defaultZoom;
    super.initState();

    if (widget.sharedPrefs.getDouble('long') != null) {
      putMarker();
      getAddress();
    }
  }

  @override
  void dispose() {
    mapController.dispose();
    textController.dispose();
    super.dispose();
  }

  void search() async {
    FocusScope.of(context).unfocus();
    List<Location> places = await locationFromAddress(textController.text);
    setState(() {
      newLongitude = places[0].longitude;
      newLatitude = places[0].latitude;
      searchLocation = true;
      if (mapController.markersCount > 0) {
        markerExist = true;
        mapController.clearMarkers();
      }
    });
    _zoomPanBehavior.focalLatLng = MapLatLng(newLatitude, newLongitude);
    _zoomPanBehavior.zoomLevel = 16;
    mapController.insertMarker(0);
  }

  void getAddress() async {
    List<Placemark> addresses = [];
    try {
      addresses = await placemarkFromCoordinates(newLatitude, newLongitude);
    } catch(e) {
      if (e is PlatformException) {
        textController.text = '!!Unknown Area!!';
        return;
      }
    }
    addresses = addresses.where((element) =>
    !(element.name!.contains('+') || element.name!.contains('Unnamed'))
    ).toList();

    textController.text = addresses[0].street ?? textController.text;
    String city =
      (addresses[0].subLocality != ''
        ? addresses[0].subLocality : null) ??
          (addresses[0].subAdministrativeArea != ''
            ? addresses[0].subAdministrativeArea : null) ?? '---';
    address = city + ',' + (addresses[0].country ?? '---');
  }

  void onTapLocation(details) async {
    markerPosition = mapController.pixelToLatLng(
        Offset(details.localPosition.dx, details.localPosition.dy)
    );
    setState(() {
      newLongitude = markerPosition.longitude;
      newLatitude = markerPosition.latitude;
      if (mapController.markersCount > 0) {
        mapController.clearMarkers();
      }
    });
    mapController.insertMarker(0);
    getAddress();
  }

  void alertUser() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('NO Input!!'),
          content: const Text('Please Provide a location to gain the data from.'),
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
          title: const Text('NO Input!!'),
          content: const Text('Please Provide a location to gain the data from.'),
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

  Future<bool> save({bool button = false}) async {
    if ((longitude == double.negativeInfinity
        || latitude == double.negativeInfinity)
        && !((pickLocation || autoLocation || searchLocation) && button)) {
      alertUser();
      return false;
    }
    if ((pickLocation || autoLocation || searchLocation) && button) {
      widget.sharedPrefs.setDouble('long', newLongitude);
      widget.sharedPrefs.setDouble('lat', newLatitude);
    } else {
      widget.sharedPrefs.setDouble('long', longitude);
      widget.sharedPrefs.setDouble('lat', latitude);
    }
    widget.sharedPrefs.setString('address', address);
    widget.sharedPrefs.setBool('welcome', false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff132030),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () async {if (await save(button: true)) {
              welcome ? Navigator.pushReplacementNamed(context, '/home')
                  : Navigator.pop(context);
            }},
            icon: const Icon(Icons.save),
            iconSize: 24,
          )
        ],
      ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: save,
          child: Column(
            children: [
              // Title
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Location Tracker',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: textController,
                        style: const TextStyle(color: Colors.white),
                        onSubmitted: (_) {search();},
                        onTap: () async {
                          // showSearch(
                          //   context: context,
                          //   delegate: AddressSearch(),
                          // );
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 10, right: 3, top: 3, bottom: 3),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 3),
                          ),
                          hintText: 'Current location',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    tooltip: 'Search',
                    onPressed: search,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.my_location,
                      color: Colors.white,
                    ),
                    tooltip: 'My location',
                    onPressed: () async {
                      try {
                        location = await determinePosition();
                      } catch(e) {
                        final scaffold = ScaffoldMessenger.of(context);
                        switch (e) {
                          case('1'): {
                            scaffold.showSnackBar(
                              const SnackBar(content: Text('Location services are disabled.')),
                            );
                          } break;
                          case('2'): {
                            scaffold.showSnackBar(
                              SnackBar(
                                content: const Text('Location permissions are denied'),
                                action: SnackBarAction(
                                    label: 'RETRY',
                                    onPressed: () async {await Geolocator.requestPermission();}
                                ),
                              ),
                            );
                          } break;
                          case('3'): {
                            scaffold.showSnackBar(const SnackBar(content: Text(
                                'Location permissions are permanently denied, we cannot request permissions.'
                            )));
                          } break;
                        }
                        return;
                      }
                      setState(() {
                        autoLocation = true;
                        newLongitude = location.longitude;
                        newLatitude = location.latitude;
                        if (mapController.markersCount > 0) {
                          markerExist = true;
                          mapController.clearMarkers();
                        }
                      });
                      _zoomPanBehavior.focalLatLng = MapLatLng(newLatitude, newLongitude);
                      _zoomPanBehavior.zoomLevel = 16;
                      mapController.insertMarker(0);
                      getAddress();
                    },
                  ),
                ],
              ),
              // Map
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTapUp: pickLocation ? onTapLocation : null,
                    child: SfMaps(
                      layers: [
                        MapTileLayer(
                          controller: mapController,
                          // urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          urlTemplate: 'https://api.maptiler.com/maps/topo/{z}/{x}/{y}.png?key=$mapKey',
                          zoomPanBehavior: _zoomPanBehavior,
                          markerBuilder: (BuildContext context, int index) {
                            return MapMarker(
                              latitude: newLatitude,
                              longitude: newLongitude,
                              child: const Padding(
                                padding: EdgeInsets.only(bottom: 40),
                                child: Icon(Icons.location_on, color: Colors.red, size: 50),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Toolbar
              pickLocation || autoLocation || searchLocation
              ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        pickLocation = false;
                        autoLocation = false;
                        searchLocation = false;
                        longitude = newLongitude;
                        latitude = newLatitude;
                      });
                    },
                    icon: const Icon(Icons.check),
                    tooltip: 'Save',
                    iconSize: 30,
                  ),
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        pickLocation = false;
                        autoLocation = false;
                        searchLocation = false;
                        newLongitude = longitude;
                        newLatitude = latitude;
                        if (markerExist) {
                          if (mapController.markersCount > 0) mapController.clearMarkers();
                          mapController.insertMarker(0);
                          markerExist = false;
                        }
                      });
                      getAddress();
                    },
                    icon: const Icon(Icons.cancel_outlined),
                    tooltip: 'Cancel',
                    iconSize: 30,
                  )
                ],
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {setState(() {
                      pickLocation = !pickLocation;
                      if (mapController.markersCount > 0) markerExist = true;
                    });},
                    icon: const Icon(Icons.location_on),
                    tooltip: 'Pick Location',
                    iconSize: 30,
                  ),
                  IconButton(
                    onPressed: () {_zoomPanBehavior.zoomLevel += 0.5;},
                    icon: const Icon(Icons.add_circle_outline),
                    tooltip: 'Zoom In',
                    iconSize: 30,
                  ),
                  IconButton(
                    onPressed: () {
                      if (mapController.markersCount > 0) {
                        _zoomPanBehavior.focalLatLng = MapLatLng(newLatitude, newLongitude);
                      } else {
                        _zoomPanBehavior.focalLatLng = const MapLatLng(0, 0);
                      }
                      setState(() {_zoomPanBehavior.zoomLevel = defaultZoom;});
                    },
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh',
                    iconSize: 30,
                  ),
                  IconButton(
                    onPressed: () {_zoomPanBehavior.zoomLevel -= 0.5;},
                    icon: const Icon(Icons.remove_circle_outline),
                    tooltip: 'Zoom Out',
                    iconSize: 30,
                  ),
                  IconButton(
                    onPressed: () {if (mapController.markersCount > 0) mapController.clearMarkers();},
                    icon: const Icon(Icons.cancel_outlined),
                    tooltip: 'Delete Existing Marker',
                    iconSize: 30,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
