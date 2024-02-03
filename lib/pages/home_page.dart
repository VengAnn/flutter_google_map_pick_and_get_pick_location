import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // initialized
  LatLng mylatlong = const LatLng(21.56453682228907, 105.8214412871613);
  String address = 'Lucknow';

  setMarker(LatLng value) async {
    mylatlong = value;

    String apiUrl =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${value.latitude}&lon=${value.longitude}';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data.containsKey('display_name')) {
        setState(() {
          address = data['display_name'];
        });
        print('Address: $address');
      } else {
        print('Address not found in response');
      }
    } else {
      print(
          'Failed to fetch location details. Status Code: ${response.statusCode}');
    }

    Fluttertoast.showToast(msg: '📍' + address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: mylatlong, zoom: 12),
        markers: {
          Marker(
            infoWindow: InfoWindow(title: address),
            position: mylatlong,
            draggable: true,
            markerId: MarkerId('1'),
            onDragEnd: (value) {
              print("test value: $value");
              setMarker(value);
            },
          ),
        },
        onTap: (value) {
          setMarker(value);
        },
      ),
    );
  }
}
