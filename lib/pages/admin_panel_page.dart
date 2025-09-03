import 'package:flutter/material.dart';
import 'package:scanmyblood/utils/global_data.dart';
import 'package:scanmyblood/models/donor.dart';
import 'package:scanmyblood/models/blood_request.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  void _verifyDonor(Donor d) {
    setState(() => d.verified = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${d.name} is now verified ✅")),
    );
  }

  void _updateRequestStatus(BloodRequest r, RequestStatus s) {
    setState(() => r.status = s);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${r.requesterName}'s request updated")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final verifiedDonors = donors.where((d) => d.verified).toList();
    final pendingDonors = donors.where((d) => !d.verified).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Admin Panel'), backgroundColor: Colors.red),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text('Blood Requests',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          if (requests.isEmpty)
            const Center(child: Text('No blood requests'))
          else
            ...requests.map((r) => Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(r.requesterName),
                    subtitle: Text('${r.bloodGroup} • ${r.city}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(r.status.toString().split('.').last,
                            style: TextStyle(
                                color: r.status == RequestStatus.pending
                                    ? Colors.orange
                                    : (r.status == RequestStatus.approved
                                        ? Colors.green
                                        : Colors.red))),
                        if (r.status == RequestStatus.pending) ...[
                          IconButton(
                            icon: Icon(Icons.check, color: Colors.green),
                            onPressed: () =>
                                _updateRequestStatus(r, RequestStatus.approved),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: () =>
                                _updateRequestStatus(r, RequestStatus.rejected),
                          ),
                        ],
                      ],
                    ),
                  ),
                )),
          Divider(thickness: 2),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
                'Donor Submissions (Verified: ${verifiedDonors.length} / ${donors.length})',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          if (pendingDonors.isEmpty)
            const Center(child: Text('No pending donors'))
          else
            ...pendingDonors.map((d) => Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(d.name),
                    subtitle: Text('${d.bloodGroup} • ${d.city}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Pending ⏳',
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () => _verifyDonor(d),
                        ),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
