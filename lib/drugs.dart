import 'package:flutter/material.dart';

import 'log.dart';
import 'main.dart';

class Drug {
  late String name;
  late String? route;
  late Color? color;

  Drug(this.name, this.route, this.color);
}

class Drugs {
  List<Drug> list = [
    Drug("Adenosine", null, null),
    Drug("Amiodarone", "IV Push", null),
    Drug("Amiodarone", "IV Bolus via Minibag", null),
    Drug("Amiodarone", "IV Infusion", null),
    Drug("Aspirin", null, null),
    Drug("Atropine", null, Colors.purple),
    Drug("Calcium Chloride", null, Colors.yellow),
    Drug("Calcium Gluconate", null, null),
    Drug("Dexamethasone", null, null),
    Drug("Dextrose 50%", null, Colors.blue),
    Drug("Diazepam", "IV", null),
    Drug("Diazepam", "PR", null),
    Drug("Diltiazem", null, null),
    Drug("Direct Oral Anticoagulant (DOAC)", null, null),
    Drug("Epinephrine", "IV", Colors.brown.shade400),
    Drug("Epinephrine", "Inhaled", null),
    Drug("Esmolol", null, null),
    Drug("Labetalol", null, null),
    Drug("Lidocaine", null, Colors.red.shade200),
    Drug("Lorazepam", "IV", null),
    Drug("Lorazepam", "Intramuscular", null),
    Drug("Mannitol", null, null),
    Drug("Magnesium Sulfate", null, null),
    Drug("Methylprednisolone", null, null),
    Drug("Metoprolol", null, null),
    Drug("Midazolam", "IV", null),
    Drug("Midazolam", "Intramuscular", null),
    Drug("Naloxone", "IV", null),
    Drug("Naloxone", "Intranasal", null),
    Drug("Nicardipine", null, null),
    Drug("Nifedipine", null, null),
    Drug("Nitroglycerin", null, null),
    Drug("Nitroprusside", null, null),
    Drug("Norepinephrine", null, null),
    Drug("Phenylephrine", null, null),
    Drug("Sodium Bicarbonate", null, Colors.yellow.shade800),
  ];

  Drugs() {
    // In case they are out of alphabetical order in the declaring list...
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}

class PageDrugs extends StatelessWidget {
  final PageState _pageState;
  final Drugs _drugs = Drugs();

  PageDrugs(this._pageState, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Drugs"),
      ),
      body: Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: .start,
              children: _drugs.list.map((d) =>
                  ListTile(
                    title: Text(d.name),
                    subtitle: d.route != null ? Text(d.route!) : null,
                    trailing: d.color != null ? CircleAvatar(backgroundColor: d.color) : null,
                    onTap: () {
                      if (d.name == "Epinephrine") {
                        _pageState.pressedEpi();
                      } else {
                        _pageState.logWrite(Entry( type: EntryType.drug, description: "${d.name} administered"));
                      }
                      Navigator.pop(context);
                    },
                  )
              ).toList()
          )
        )
      )
    );
  }
}