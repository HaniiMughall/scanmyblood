// find_donor_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scanmyblood/models/donor.dart';
import 'package:scanmyblood/services/database_service.dart';
import 'package:scanmyblood/services/location_service.dart';
import 'request_flow/nearby_donors_page.dart';
import 'dart:ui';

class FindDonorPage extends StatefulWidget {
  const FindDonorPage({super.key});

  @override
  State<FindDonorPage> createState() => _FindDonorPageState();
}

class _FindDonorPageState extends State<FindDonorPage> {
  String selectedGroup = 'All';
  String searchQuery = '';
  List<Donor> allDonors = [];
  List<Donor> filteredDonors = [];
  bool loading = true;

  final List<String> groups = [
    'All',
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  @override
  void initState() {
    super.initState();
    _loadDonors();
  }

  Future<void> _loadDonors() async {
    setState(() => loading = true);
    final donors = await DatabaseService.instance.getAllDonors();
    setState(() {
      allDonors = donors;
      _filterDonors();
      loading = false;
    });
  }

  void _filterDonors() {
    final lowerQuery = searchQuery.toLowerCase();
    setState(() {
      filteredDonors = allDonors.where((d) {
        final matchesGroup =
            selectedGroup == 'All' || d.bloodGroup == selectedGroup;
        final matchesQuery = d.name.toLowerCase().contains(lowerQuery) ||
            d.city.toLowerCase().contains(lowerQuery) ||
            d.contact.toLowerCase().contains(lowerQuery);
        return matchesGroup && matchesQuery;
      }).toList();
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
        title: const Text('Find Donor'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.black87],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on, color: Colors.white),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const NearbyDonorPage()));
            },
            tooltip: "Nearby Donors",
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.red],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Filters (glass)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.black87,
                            value: selectedGroup,
                            isExpanded: true,
                            style: const TextStyle(color: Colors.white),
                            items: groups
                                .map((group) => DropdownMenuItem(
                                      value: group,
                                      child: Text(group,
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                selectedGroup = val;
                                _filterDonors();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Search by city/name/contact',
                              hintStyle: TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.06),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                            ),
                            onChanged: (val) {
                              searchQuery = val;
                              _filterDonors();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : filteredDonors.isEmpty
                      ? const Expanded(
                          child: Center(
                              child: Text('No donors found',
                                  style: TextStyle(color: Colors.white70))))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: filteredDonors.length,
                            itemBuilder: (ctx, i) {
                              final d = filteredDonors[i];
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.06),
                                        borderRadius: BorderRadius.circular(16),
                                        border:
                                            Border.all(color: Colors.white24),
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.red.shade100,
                                          child: Text(d.bloodGroup,
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        title: Text(d.name,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600)),
                                        subtitle: Text(
                                            '${d.city} • ${d.contact}',
                                            style: const TextStyle(
                                                color: Colors.white70)),
                                        trailing: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: d.verified
                                                ? Colors.green
                                                : Colors.red,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                          ),
                                          onPressed: d.verified
                                              ? null
                                              : () => _onContact(d),
                                          child: Text(d.verified
                                              ? 'Verified ✅'
                                              : 'Contact'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
