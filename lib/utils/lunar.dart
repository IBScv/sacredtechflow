/**
 * This uses a solid approximate method: compute days since a known new moon (2000-01-06 18:14 UTC), divide by 
 * synodic month (29.530588853), get fractional cycle and map to named phase.
 */

import 'dart:math';

class LunarPhase {
  static const double synodicMonth = 29.530588853;

  // Base new moon: 2000-01-06 18:14 UTC (well-known reference)
  static final DateTime baseNewMoonUtc = DateTime.utc(2000, 1, 6, 18, 14);

  /// Returns moon age in days (0..~29.53)
  static double moonAge(DateTime date) {
    final utc = date.toUtc();
    final diff = utc.difference(baseNewMoonUtc).inSeconds / 86400.0; // days
    final cycles = diff / synodicMonth;
    final frac = cycles - cycles.floorToDouble();
    final age = frac * synodicMonth;
    return age < 0 ? age + synodicMonth : age;
  }

  /// Human-readable phase name
  static String phaseName(DateTime date) {
    final age = moonAge(date);

    // boundaries (days) derived from equidistant phase ranges
    if (age < 1.84566) return 'New Moon';
    if (age < 5.53699) return 'Waxing Crescent';
    if (age < 9.22831) return 'First Quarter';
    if (age < 12.91963) return 'Waxing Gibbous';
    if (age < 16.61096) return 'Full Moon';
    if (age < 20.30228) return 'Waning Gibbous';
    if (age < 23.99361) return 'Last Quarter';
    if (age < 27.68493) return 'Waning Crescent';
    return 'New Moon';
  }
}
