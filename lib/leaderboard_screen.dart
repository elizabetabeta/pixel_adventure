import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class LeaderboardScreen extends StatelessWidget {
  final DatabaseReference databaseReference;

  const LeaderboardScreen({super.key, required this.databaseReference});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.leaderboard, size: 28, color: Colors.white,), // Ikona u lijevom kutu
            const SizedBox(width: 10),
            const Text(
              "Leaderboard",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color:Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple, // pozadina
      ),
      body: FutureBuilder<DatabaseEvent>(
        future: databaseReference.child("users").orderByChild("points").once(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            final Map<dynamic, dynamic> users = snapshot.data!.snapshot.value as Map;
            final entries = users.entries.toList();

            // Sortiranje 
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

                // boje bodova u ovisnosti koliko je vrijednost
                final pointsColor = points > 10 ? Colors.green : Colors.red;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Text("${index + 1}",
                      style: TextStyle(
                          color: Colors.white, 
                          fontWeight: FontWeight.bold,
                        ),
                        ), // Rang korisnika
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            email,
                            overflow: TextOverflow.ellipsis, // Prekid linije ako je ime predugo
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "$points pts",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: pointsColor, // boja bodova
                          ),
                        ),
                      ],
                    ),
                  ),
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
