import 'package:flutter/material.dart';

import 'log.dart';
import 'main.dart';

class Event {
  late String name;
  late String description;

  Event(this.name, this.description);
}

class Events {
  List<Event> list = [
    Event("Assumed Care", "Assumed care of patient"),
    Event("Dispatch Received", "Dispatch received"),
    Event("Dispatch Acknowledged", "Dispatch acknowledged"),
    Event("En Route", "En route"),
    Event("On Scene", "Arrived on scene"),
    Event("On Site", "Arrived on site"),
    Event("Return of Spontaneous Circulation (ROSC)", "Achieved return of spontaneous circulation (ROSC)"),
    Event("Time of Death Pronounced", "Time of death pronounced"),
    Event("Transferred Care", "Transferred care of patient"),
    Event("Transporting", "Transporting patient"),
  ];

  Events () {
    // In case they are out of alphabetical order in the declaring list...
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}

class PageEvents extends StatelessWidget {
  final PageState _pageState;
  final Events _events = Events();

  PageEvents(this._pageState, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Events"),
        ),
        body: Expanded(
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: .start,
                  children: _events.list.map((e) =>
                      ListTile(
                        title: Text(e.name),
                        onTap: () {
                          _pageState.log.add(Entry(
                              type: EntryType.event,
                              description: e.description));
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