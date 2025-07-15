import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NGOScreen extends StatelessWidget {
  @override
  const NGOScreen({Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NGO Dashboard')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('donations')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final donations = snapshot.data!.docs;
          return ListView.builder(
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final data = donations[index];
              return Card(
                child: ListTile(
                  leading: Image.network(data['image_url'], width: 60, height: 60, fit: BoxFit.cover),
                  title: Text(data['food_name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pickup: ${data['location']}"),
                      if (data['match'] != null) Text("Match: ${data['match']}"),
                      if (data['expiry'] != null) Text("Freshness: ${data['expiry']}"),
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
