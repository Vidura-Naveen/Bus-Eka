import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusIssuesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Issues'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseService.getIssuesStream(), // Fetch issues from Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No bus issues available.'),
            );
          }

          // Display bus issues in a ListView
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var issue = snapshot.data!.docs[index];
              var userName = issue['userName'];
              var issueText = issue['issueText'];
              var timestamp = issue['timestamp'];

              return Card(
                child: ListTile(
                  title: Text(userName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(issueText),
                      Text(
                        'Timestamp: ${timestamp.toDate()}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class FirebaseService {
  static final CollectionReference _issueCollection =
      FirebaseFirestore.instance.collection('issuecollection');

  // Fetch issues from Firestore
  static Stream<QuerySnapshot> getIssuesStream() {
    return _issueCollection.orderBy('timestamp', descending: true).snapshots();
  }
}
