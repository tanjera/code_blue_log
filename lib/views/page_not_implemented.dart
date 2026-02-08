import 'package:code_blue_log/views/page_recorder.dart';
import 'package:flutter/material.dart';

import 'page_main.dart';
import '../classes/procedures.dart';
import '../classes/log.entry.dart';

class PageNotImplemented extends StatelessWidget {

  const PageNotImplemented({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Not Implemented"),
      ),
      body: Column(
        mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            Text('This feature has not been implemented yet, but will be implemented in a version in the near future!',
            textAlign: TextAlign.center)
        ]
      )
    );
  }
}