import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

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
        return "Level 2 - Množenje : \n Naučit ćete osnovne pojmove postupke množenja ."
          	"Razumjeti znak × (množenje).\n"
          
            "Množenje je matematička operacija kojom zbrajamo isti broj više puta. \n Na primjer, ako želimo zbrojiti broj 3 četiri puta \n (3 + 3 + 3 + 3), to možemo zapisati kao 3 × 4. "
            ;
      case 3:
        return "Zadnji level - Dijeljenje! Kombinirajte matematiku i spretnost kako biste završili igru!"
        "Dijeljenje je matematička operacija kojom raspoređujemo broj u jednake dijelove. \n Na primjer, ako imamo 12 jabuka i želimo ih podijeliti među 3 prijatelja, \n svaki će dobiti 4 jabuke, što zapisujemo kao 12 ÷ 3 = 4."
        "Znak  ÷ (dijeljenje)";
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
