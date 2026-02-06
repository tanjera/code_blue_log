import 'package:flutter/material.dart';

import 'log.dart';
import 'main.dart';

class Procedure {
  late String title;
  late String? subtitle;
  late String log;
  late Color? color;

  Procedure(this.title, this.subtitle, this.log, this.color);
}

class Procedures {
  final List<Procedure> list = [
    Procedure("Bronchoscopy", null, "Bronchoscopy conducted", null),
    Procedure("Cardioversion", null, "Cardioversion completed", null),
    Procedure("Central Line", null, "Central line placed", null),
    Procedure("Chest Tube", null, "Chest tube placed", null),
    Procedure("Cricothyrotomy", null, "Cricothyrotomy placed", null),
    Procedure("Delivered Baby", null, "Delivered the baby", null),
    Procedure("Fetal Heart Rate", null, "Fetal heart rate assessed", null),
    Procedure("Intraosseous Line", null, "Intraosseous line placed", Colors.yellow.shade800),
    Procedure("Intravenous Line", null, "Intravenous line placed", null),
    Procedure("Intubation", "Endotracheal (ETT)", "Endotracheal intubation", null),
    Procedure("Intubation", "Laryngeal Mask Airway (LMA)", "Laryngeal mask intubation", null),
    Procedure("Thoracotomy", null, "Thoracotomy conducted", null),
    Procedure("Transcutaneous Pacing", "Started", "Started transcutaneous pacing", null),
    Procedure("Transcutaneous Pacing", "Stopped", "Stopped transcutaneous pacing", null),
    Procedure("Transvenous Pacing", "Started", "Started transvenous pacing", null),
    Procedure("Transvenous Pacing", "Stopped", "Stopped transvenous pacing", null),
  ];

  Procedures() {
    // In case they are out of alphabetical order in the declaring list...
    list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
  }
}

class PageProcedures extends StatelessWidget {
  final PageState _pageState;
  final Procedures _procedures = Procedures();

  PageProcedures(this._pageState, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Procedures"),
      ),
      body: Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: .start,
              children: _procedures.list.map((p) =>
                ListTile(
                  title: Text(p.title),
                  subtitle: p.subtitle != null ? Text(p.subtitle!) : null,
                  trailing: p.color != null ? CircleAvatar(backgroundColor: p.color) : null,
                  onTap: () {
                    _pageState.log.add(Entry(
                      type: EntryType.procedure,
                              description: p.log));
                    _pageState.updateUI();
                    Navigator.pop(context);
                  },
                )
            ).toList(),
          )
        )
      )
    );
  }
}