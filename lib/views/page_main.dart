import 'dart:core';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'page_recorder.dart';
import 'page_not_implemented.dart';

import '../main.dart';

class PageMain extends StatefulWidget {
  const PageMain({super.key, required this.title});

  final String title;

  @override
  State<PageMain> createState() => PageMainState();
}

class PageMainState extends State<PageMain> {
  String _version = "";
  int _selectedIndex = 0;

  PageMainState() {
    getVersion();
  }

  void getVersion () async {
    PackageInfo _pi = await PackageInfo.fromPlatform();

    setState(() {
      _version = "v ${_pi.version}";
    });
  }


  static const List<Widget> _widgetOptions = <Widget>[
    PageRecorder(title: appTitle),
    PageNotImplemented(),
    PageNotImplemented(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Recorder'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Logs'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}