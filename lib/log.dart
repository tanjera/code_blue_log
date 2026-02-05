import 'dart:io';

import 'package:code_blue_log/event.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

enum EntryType {
  cpr,
  drug,
  shock,
  procedure,
  event
}

class Entry {
  late DateTime occurred;
  EntryType type;
  String description;

  Entry ({required this.type, required this.description}) {
    occurred = DateTime.now();
  }

  Entry.m ({required this.occurred, required this.type, required this.description});

  String operator [] (String key) {
    switch (key) {
      case 'occurred':
        return DateFormat.Hms().format(occurred);
      case 'type':
        return type.toString();
      case 'description':
        return description;
      default:
        return "";
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'occurred': occurred.toIso8601String(),
      'type': type.toString(),
      'description': description
    };
  }

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry.m(
      occurred: DateTime.parse(json['occurred']),
      type: EntryType.values.firstWhere((e) => e.toString() == json['type']),
      description: json['description'] as String
    );
  }
}

class Log {
  final String _filename;

  Log(this._filename);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_filename');
  }

  Future<String?> read() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return null;
    }
  }

  Future<File> write(String contents) async {
    final file = await _localFile;
    return file.writeAsString(contents, flush: true);
  }
}