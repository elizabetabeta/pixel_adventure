import 'package:flutter/material.dart';


class LessonOverlay extends StatelessWidget {
  final int level;
  final VoidCallback onStart;

  const LessonOverlay({super.key, required this.level, required this.onStart});

  String getLessonText() {
    switch (level) {
      case 1:
        return "\n\n  Dobrodošli u Level 1 - Veći i manji broj!\n\n  Ovdje ćete naučiti osnove matematike i prikupljati voćkice! \n \n"
                "Cilj lekcije jeste naučiti kako uspoređivati brojeve. \n Razumjeti što znače znakovi veće od (>) i manje od (<). \n \n"
                "Što znači veći, a što manji broj? \n\n  Ako uspoređujemo dva broja, veći broj dolazi nakon manjeg kada brojimo.\n\n\n "
                "Znakovi usporedbe: \n\n Manje od → <\n\n Veće od → > \n\n Pravilo: Znak uvijek pokazuje prema manjem broju!";
      case 2:
        return "\n\n  Level 2 - Množenje : \n \n Naučit ćete osnovne pojmove postupke množenja .\n"
                "Razumjeti znak × (množenje).\n"
                "Množenje je matematička operacija kojom zbrajamo isti broj više puta.  \n\n Na primjer, ako želimo zbrojiti broj 3 četiri puta, \n (3 + 3 + 3 + 3), to možemo zapisati kao 3 × 4. ";
      case 3:
        return " \n\n Zadnji level - Dijeljenje! \n \n Kombinirajte matematiku i spretnost kako biste završili igru! \n"
               "Dijeljenje je matematička operacija kojom raspoređujemo broj u jednake dijelove. \n \nNa primjer, ako imamo 12 jabuka i želimo ih podijeliti među 3 prijatelja, \n svaki će dobiti 4 jabuke, što zapisujemo kao 12 ÷ 3 = 4."
               "\n\n Znak  ÷ (dijeljenje)";
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
                    style: const TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'Arial'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // boja buttona
              ElevatedButton(
                onPressed: onStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "Start Level",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
