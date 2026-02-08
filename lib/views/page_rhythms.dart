import 'package:flutter/material.dart';

import 'page_recorder.dart';
import '../classes/log.entry.dart';
import '../classes/rhythms.dart';



class PageRhythms extends StatelessWidget {
  final PageRecorderState _prs;
  final Rhythms _rhythms = Rhythms();

  PageRhythms(this._prs, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Cardiac Rhythms"),
        ),
        body: Expanded(
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: .start,
                  children: _rhythms.list.map((r) =>
                      ListTile(
                        title: Text(r.name),
                        trailing: r.color != null ? CircleAvatar(backgroundColor: r.color) : null,
                        onTap: () {
                          _prs.log.add(Entry(
                              type: EntryType.rhythm,
                              description: "Cardiac rhythm: ${r.name}"));
                          _prs.updateUI();
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