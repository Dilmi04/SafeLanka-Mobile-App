import 'package:flutter/material.dart';
import '../models/report_model.dart';
import '../services/firebase_service.dart';
import 'report_details_screen.dart';
import 'missing_report_screen.dart';

class MissingPersonsListScreen extends StatelessWidget {
  const MissingPersonsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseService _firebaseService = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFBFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Missing Persons', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: StreamBuilder<List<ReportModel>>(
        stream: _firebaseService.getReports(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No missing person reports found.'));
          }

          final reports = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                  border: Border.all(color: Colors.grey.withOpacity(0.12)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MissingPersonDetailsScreen(report: report)),
                    );
                  },
                  leading: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: report.imageUrl.isNotEmpty
                          ? Image.network(
                              // Robust Proxy for Web Images
                              "https://images.weserv.nl/?url=" + Uri.encodeComponent(report.imageUrl),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, color: Colors.grey),
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                              },
                            )
                          : const Icon(Icons.person, color: Colors.grey),
                    ),
                  ),
                  title: Text(report.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text("Age: ${report.age}\nLast seen: ${report.lastSeenLocation}",
                    maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () async {
                      bool confirm = await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Report'),
                          content: const Text('Are you sure you want to delete this report?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      ) ?? false;

                      if (confirm && report.id != null) {
                        await _firebaseService.deleteReport(report.id!);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportMissingPersonScreen()));
        },
        label: const Text('Report Missing'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF6366F1),
      ),
    );
  }
}
