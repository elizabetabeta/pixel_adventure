import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class LeaderboardScreen extends StatelessWidget {
  final DatabaseReference databaseReference;

  const LeaderboardScreen({super.key, required this.databaseReference});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leaderboard")),
      body: FutureBuilder<DatabaseEvent>(
        future: databaseReference.child("users").orderByChild("points").once(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            final Map<dynamic, dynamic> users = snapshot.data!.snapshot.value as Map;
            final entries = users.entries.toList();

            // Sortiranje po bodovima od najvećeg prema najmanjem
            entries.sort((a, b) {
              final int aPoints = a.value["points"] ?? 0;
              final int bPoints = b.value["points"] ?? 0;
              return bPoints.compareTo(aPoints);
            });

            return ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final user = entries[index];
                final email = user.value["email"] ?? "Unknown";
                final points = user.value["points"] ?? 0;

                return ListTile(
                  leading: CircleAvatar(child: Text("${index + 1}")),
                  title: Text(email),
                  trailing: Text("$points pts"),
                );
              },
            );
          }

          return const Center(child: Text("No data found."));
        },
      ),
    );
  }
}
