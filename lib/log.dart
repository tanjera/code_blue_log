import 'dart:convert';
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
  String? filename;
  String? identifier;
  DateTime? created;

  List<Entry> entries = [];

  void add (Entry e) async {
    entries.add(e);
    write();
  }

  void write() async {
    created ??= DateTime.now();
    filename ??= "${created!.toIso8601String()}.json";

    final file = await _localFile(filename ?? "");

    file.writeAsString(
        JsonEncoder.withIndent("  ").convert({
          "identifier": identifier,
          "created": created!.toIso8601String(),
          "entries": entries.map((e) => e.toJson()).toList()
        }),
        flush: true);


    final l = read(filename ?? "");
  }

  Future<Log?> read (String filename) async {
    try {
      final file = await _localFile(filename);
      String? input = await file.readAsString();

      if (input.isEmpty) {
        return null;
      }

      Log log = Log();
      
      var dAll = json.decode(input ?? "");

      // Decode the header
      log.identifier = dAll["identifier"];
      log.created = DateTime.parse(dAll["created"]);

      // Decode the body of the file (the Entries)
      log.entries = (dAll["entries"] as List<dynamic>)
          .map((e) => Entry.fromJson(e as Map<String, dynamic>))
          .toList();

      return log;
    } catch (e) {
      return null;
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile (String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }
}