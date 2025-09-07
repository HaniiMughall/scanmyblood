// nearby_donors_page.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/donor.dart';
import '../../services/database_service.dart';
import '../../services/location_service.dart';
import 'dart:ui';

class NearbyDonorPage extends StatefulWidget {
  const NearbyDonorPage({super.key});

  @override
  State<NearbyDonorPage> createState() => _NearbyDonorPageState();
}

class _NearbyDonorPageState extends State<NearbyDonorPage> {
  List<Donor> nearbyDonors = [];
  bool loading = true;
  double? currentLat;
  double? currentLon;

  @override
  void initState() {
    super.initState();
    _initLocationAndLoad();
  }

  Future<void> _initLocationAndLoad() async {
    setState(() => loading = true);
    final hasPermission = await LocationService.checkPermission();
    if (!hasPermission) {
      final granted = await LocationService.requestPermission();
      if (!granted) {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission denied ❌'),
          ),
        );
        return;
      }
    }

    final pos = await LocationService.getCurrentPosition();
    if (pos == null) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to get current location ❌'),
        ),
      );
      return;
    }

    currentLat = pos.latitude;
    currentLon = pos.longitude;
    await _loadNearbyDonors();
  }

  Future<void> _loadNearbyDonors() async {
    final all = await DatabaseService.instance.getAllDonors();
    final filtered =
        all.where((d) => d.latitude != null && d.longitude != null).toList();

    filtered.sort((a, b) {
      final distA = LocationService.distanceBetweenKm(
          currentLat!, currentLon!, a.latitude!, a.longitude!);
      final distB = LocationService.distanceBetweenKm(
          currentLat!, currentLon!, b.latitude!, b.longitude!);
      return distA.compareTo(distB);
    });

    setState(() {
      nearbyDonors = filtered;
      loading = false;
    });
  }

  Future<void> _onContact(Donor donor) async {
    final Uri telUri = Uri(scheme: 'tel', path: donor.contact);
    if (await canLaunchUrl(telUri)) await launchUrl(telUri);

    final whatsappUrl = Uri.parse(
        "https://wa.me/${donor.contact.replaceAll('-', '')}?text=Hello,%20I%20need%20blood%20donation");
    if (await canLaunchUrl(whatsappUrl)) await launchUrl(whatsappUrl);

    donor.verified = true;
    await DatabaseService.instance.addDonor(donor, pendingSync: false);

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${donor.name} contacted & verified ✅')));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Nearby Donors"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient:
                    LinearGradient(colors: [Colors.red, Colors.black87]))),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.black87, Colors.red])),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : nearbyDonors.isEmpty
                ? const Center(
                    child: Text("No nearby donors found",
                        style: TextStyle(color: Colors.white70)))
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView.builder(
                      itemCount: nearbyDonors.length,
                      itemBuilder: (ctx, i) {
                        final d = nearbyDonors[i];
                        final distance = LocationService.distanceBetweenKm(
                            currentLat!,
                            currentLon!,
                            d.latitude!,
                            d.longitude!);
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: ListTile(
                                  title: Text(d.name,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                  subtitle: Text(
                                      "${d.bloodGroup} • ${d.city} • ${distance.toStringAsFixed(1)} km away",
                                      style: const TextStyle(
                                          color: Colors.white70)),
                                  trailing: ElevatedButton(
                                    onPressed:
                                        d.verified ? null : () => _onContact(d),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: d.verified
                                          ? Colors.green
                                          : Colors.red,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                    child: Text(
                                        d.verified ? 'Verified ✅' : 'Contact'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
