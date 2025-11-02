import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../models/synchronicity_entry.dart';

class SynchronicityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final entries = app.synchronicities
      ..sort((a, b) => b.date.compareTo(a.date));

    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: Text("Synchronicity Signs")),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final e = entries[index];
            final isToday =
                e.date.day == today.day &&
                e.date.month == today.month &&
                e.date.year == today.year;

            return Dismissible(
              key: Key(e.key.toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => app.deleteSyncEntry(index),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                color: e.isPrimary ? Colors.amber[800] : Colors.grey[900],
                child: ExpansionTile(
                  title: Row(
                    children: [
                      if (isToday) Icon(Icons.star, color: Colors.yellowAccent),
                      SizedBox(width: 6),
                      Text(
                        "${DateFormat.yMMMd().format(e.date)} • ${e.type}",
                        style: TextStyle(
                          color: Colors.amberAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      RatingBarIndicator(
                        rating: e.intensity.toDouble(),
                        itemBuilder: (_, __) =>
                            Icon(Icons.star, color: Colors.tealAccent),
                        itemCount: 5,
                        itemSize: 16,
                      ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelValue("Observation:", e.observation),
                          _buildLabelValue("Feeling:", e.feeling),
                          _buildLabelValue("Action Inspired:", e.action ?? "—"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabelValue(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.tealAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value, style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
