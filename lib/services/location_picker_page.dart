import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  LatLng _selectedLatLng = const LatLng(24.8607, 67.0011); // default Karachi
  String _pickedAddress = "Move marker to select location";
  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getUserCurrentLocation();
  }

  Future<void> _getUserCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _selectedLatLng = LatLng(position.latitude, position.longitude);
      });
      mapController.move(_selectedLatLng, 15);
      await _updateAddress(_selectedLatLng);
    } catch (e) {
      debugPrint("Location error: $e");
    }
  }

  Future<void> _updateAddress(LatLng latLng) async {
    try {
      final placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final address = [
          p.street,
          p.locality,
          p.country,
        ].where((s) => s != null && s.isNotEmpty).join(", ");
        setState(() {
          _pickedAddress = address;
        });
      } else {
        setState(() {
          _pickedAddress = "${latLng.latitude}, ${latLng.longitude}";
        });
      }
    } catch (e) {
      debugPrint("Reverse geocoding failed: $e");
      setState(() {
        _pickedAddress = "${latLng.latitude}, ${latLng.longitude}";
      });
    }
  }

  void _onConfirm() {
    Navigator.pop(context, {
      "lat": _selectedLatLng.latitude,
      "lng": _selectedLatLng.longitude,
      "address": _pickedAddress,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick Location")),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: _selectedLatLng,
                initialZoom: 14,
                onTap: (tapPosition, pos) {
                  setState(() => _selectedLatLng = pos);
                  _updateAddress(pos);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLatLng,
                      width: 60,
                      height: 60,
                      child: const Icon(Icons.location_pin,
                          size: 50, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  _pickedAddress,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _onConfirm,
                  child: const Text("Confirm Location"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
