import 'package:uuid/uuid.dart';

class LunarEntry {
  final String id;
  final DateTime date;
  final String phase; // e.g. "New Moon", "Waxing"
  final int mood; // 1-10
  final List<String> gratitude; // up to 3
  final String energyTone; // Calm / Focused / Inspired / Tired
  final String action; // what you created
  final double moneyIn;
  final double moneyOut;
  final String synchronicity;
  final String dream;

  LunarEntry({
    String? id,
    required this.date,
    required this.phase,
    required this.mood,
    required this.gratitude,
    required this.energyTone,
    required this.action,
    required this.moneyIn,
    required this.moneyOut,
    required this.synchronicity,
    required this.dream,
  }) : id = id ?? Uuid().v4();

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date.toIso8601String(),
    'phase': phase,
    'mood': mood,
    'gratitude': gratitude,
    'energyTone': energyTone,
    'action': action,
    'moneyIn': moneyIn,
    'moneyOut': moneyOut,
    'synchronicity': synchronicity,
    'dream': dream,
  };

  static LunarEntry fromMap(Map<String, dynamic> m) => LunarEntry(
    id: m['id'],
    date: DateTime.parse(m['date']),
    phase: m['phase'],
    mood: m['mood'],
    gratitude: List<String>.from(m['gratitude'] ?? []),
    energyTone: m['energyTone'],
    action: m['action'],
    moneyIn: (m['moneyIn'] ?? 0).toDouble(),
    moneyOut: (m['moneyOut'] ?? 0).toDouble(),
    synchronicity: m['synchronicity'] ?? '',
    dream: m['dream'] ?? '',
  );
}
