import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../models/synchronicity_entry.dart';

class DailyDashboard extends StatelessWidget {
  const DailyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final entries = app.synchronicities;

    final today = DateTime.now();
    final todayEntries = entries
        .where(
          (e) =>
              e.date.day == today.day &&
              e.date.month == today.month &&
              e.date.year == today.year,
        )
        .toList();

    SynchronicityEntry? primaryEntry = todayEntries
        .cast<SynchronicityEntry?>()
        .firstWhere((e) => e!.isPrimary, orElse: () => null);

    // Weekly trend: last 7 days
    final week = List.generate(
      7,
      (i) => DateTime(today.year, today.month, today.day - i),
    );
    final weeklyCounts = week
        .map(
          (d) => entries
              .where(
                (e) =>
                    e.date.year == d.year &&
                    e.date.month == d.month &&
                    e.date.day == d.day,
              )
              .length,
        )
        .toList();

    final weeklyIntensity = week.map((d) {
      final dayEntries = entries.where(
        (e) =>
            e.date.year == d.year &&
            e.date.month == d.month &&
            e.date.day == d.day,
      );
      if (dayEntries.isEmpty) return 0.0;
      return dayEntries.map((e) => e.intensity).reduce((a, b) => a + b) /
          dayEntries.length;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Daily Dashboard")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today’s Primary Signal",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.amberAccent,
              ),
            ),
            SizedBox(height: 8),
            ?primaryEntry != null ? _buildPrimaryCard(primaryEntry) : null,
            SizedBox(height: 24),
            Text(
              "Weekly Synchronicity Trend",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.amberAccent,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: week.length,
                itemBuilder: (context, index) {
                  final day = week[index];
                  return ListTile(
                    leading: Text(
                      DateFormat.E().format(day),
                      style: TextStyle(color: Colors.tealAccent),
                    ),
                    title: LinearProgressIndicator(
                      value:
                          weeklyCounts[index] /
                          5.0, // assume 5+ entries max for visualization
                      color: Colors.amberAccent,
                      backgroundColor: Colors.grey[800],
                    ),
                    trailing: Text(
                      weeklyIntensity[index].toStringAsFixed(1),
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryCard(SynchronicityEntry e) {
    return Card(
      color: Colors.amber[800],
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${e.type} • ${DateFormat.yMMMd().format(e.date)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Observation: ${e.observation}",
              style: TextStyle(color: Colors.black87),
            ),
            Text(
              "Feeling: ${e.feeling}",
              style: TextStyle(color: Colors.black87),
            ),
            Text(
              "Action: ${e.action ?? '—'}",
              style: TextStyle(color: Colors.black87),
            ),
            SizedBox(height: 8),
            Row(
              children: List.generate(
                e.intensity,
                (i) => Icon(Icons.star, color: Colors.tealAccent, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
