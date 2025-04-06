import 'package:flutter/material.dart';


class LessonOverlay extends StatelessWidget {
  final int level;
  final VoidCallback onStart;

  const LessonOverlay({super.key, required this.level, required this.onStart});

  String getLessonText() {
    switch (level) {
      case 1:
        return "Dobrodošli u Level 1 - Veći i manji broj! Ovdje ćete naučiti osnove matematike i prikupljati voćkice! \n \n"
                "Cilj lekcije jeste naučiti kako uspoređivati brojeve. \n Razumjeti što znače znakovi veće od (>) i manje od (<). \n \n"
                "Što znači veći, a što manji broj? \n\n  Ako uspoređujemo dva broja, veći broj dolazi nakon manjeg kada brojimo.\n\n\n "
                "Znakovi usporedbe: \n\n Manje od → <\n\n Veće od → > \n\n Pravilo: Znak uvijek pokazuje prema manjem broju!";
      case 2:
        return "Level 2: Vrijeme je za prvi matematički zadatak! Riješite ga kako biste nastavili dalje.";
      case 3:
        return "Zadnji level! Kombinirajte matematiku i spretnost kako biste završili igru!";
      default:
        return "Dobrodošli u igru!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    getLessonText(),
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onStart,
                child: const Text("Start Level"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
