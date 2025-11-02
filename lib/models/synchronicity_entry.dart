import 'package:hive/hive.dart';

part 'synchronicity_entry.g.dart';

@HiveType(typeId: 0)
class SynchronicityEntry extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  String type; // e.g., Numbers, Dream, Coincidence

  @HiveField(2)
  String observation;

  @HiveField(3)
  String feeling;

  @HiveField(4)
  String? action;

  @HiveField(5)
  int intensity; // 1-5

  @HiveField(6)
  bool isPrimary; // daily main signal

  SynchronicityEntry({
    required this.date,
    required this.type,
    required this.observation,
    required this.feeling,
    this.action,
    this.intensity = 3,
    this.isPrimary = false,
  });
}
