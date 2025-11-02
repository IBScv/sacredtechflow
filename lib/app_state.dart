import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ibs_sacred_tech_flow/models/lunar_entry.dart';
//import 'package:ibs_sacred_tech_flow/models/lunar_entry.dart';
import 'models/synchronicity_entry.dart';

class AppState extends ChangeNotifier {
  Box<SynchronicityEntry>? _box;

  List<SynchronicityEntry> get synchronicities => _box?.values.toList() ?? [];

  Null get entries => null;
  Box get box => Hive.box('lunarEntries');

  List<LunarEntry> get lunars {
    final raw = box.values.cast<String>();
    return raw.map((s) => LunarEntry.fromMap(json.decode(s))).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  //add Lunar Entries
  Future<void> addEntry(LunarEntry e) async {
    await box.put(e.id, json.encode(e.toMap()));
    notifyListeners();
  }

  //remove Lunar entries
  Future<void> deleteEntry(String id) async {
    await box.delete(id);
    notifyListeners();
  }

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SynchronicityEntryAdapter());
    _box = await Hive.openBox<SynchronicityEntry>('synchronicities');
    notifyListeners();
  }

  void addSyncEntry(SynchronicityEntry entry) {
    // mark primary for the day
    if (entry.isPrimary) {
      for (var e in synchronicities) {
        if (e.date.day == entry.date.day &&
            e.date.month == entry.date.month &&
            e.date.year == entry.date.year) {
          e.isPrimary = false;
          e.save();
        }
      }
    }
    _box?.add(entry);
    notifyListeners();
  }

  void deleteSyncEntry(int index) {
    _box?.getAt(index)?.delete();
    notifyListeners();
  }
}
