import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/donor.dart';
import '../../services/database_service.dart';
import '/widgets/theme_page.dart';

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
      SnackBar(content: Text('${donor.name} contacted & verified ✅')),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ThemedPage(
      title: "Find Donor",
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔎 Filters
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedGroup,
                        isExpanded: true,
                        items: groups
                            .map((group) => DropdownMenuItem(
                                  value: group,
                                  child: Text(group),
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
                        decoration: const InputDecoration(
                          hintText: "Search by city/name/contact",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) {
                          searchQuery = val;
                          _filterDonors();
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                loading
                    ? const CircularProgressIndicator()
                    : filteredDonors.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "😔 No donors found",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true, // ✅ column ke andar fit karega
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredDonors.length,
                            itemBuilder: (ctx, i) {
                              final d = filteredDonors[i];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.red.shade100,
                                    child: Text(
                                      d.bloodGroup,
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  title: Text(d.name),
                                  subtitle: Text("${d.city} • ${d.contact}"),
                                  trailing: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: d.verified
                                          ? Colors.green
                                          : Colors.red.shade900,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed:
                                        d.verified ? null : () => _onContact(d),
                                    child: Text(
                                        d.verified ? "Verified ✅" : "Contact"),
                                  ),
                                ),
                              );
                            },
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
