import 'package:flutter/material.dart';
import 'package:ibs_sacred_tech_flow/app_state.dart';
import 'package:provider/provider.dart';
import '../utils/lunar.dart';
import '../models/lunar_entry.dart';
import 'package:intl/intl.dart';
import '../main.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _motto() => "I circulate value, not chase money.";

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final now = DateTime.now();
    final phase = LunarPhase.phaseName(now);
    final age = LunarPhase.moonAge(now).toStringAsFixed(1);

    // compute simple mood average
    final entries = app.lunars;
    final moodAvg = entries.isEmpty
        ? 0
        : (entries.map((e) => e.mood).reduce((a, b) => a + b) / entries.length);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sacred Tech Flow'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.tealAccent),
            onPressed: () => Navigator.pushNamed(context, '/new'),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'addEntry',
            child: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/newSynchronicity'),
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'dashboard',
            child: Icon(Icons.dashboard),
            onPressed: () => Navigator.pushNamed(context, '/dashboard'),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Moon card
            Card(
              color: Colors.black,
              child: ListTile(
                leading: Icon(
                  Icons.brightness_3,
                  color: Colors.amberAccent,
                  size: 36,
                ),
                title: Text(
                  phase,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                subtitle: Text('Moon age: $age days'),
              ),
            ),
            SizedBox(height: 12),
            // Mood & finance summary
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            'Energy',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            moodAvg == 0 ? '—' : moodAvg.toStringAsFixed(1),
                            style: TextStyle(fontSize: 28),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            'Entries',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${entries.length}',
                            style: TextStyle(fontSize: 28),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Quick list of recent entries
            Expanded(
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, idx) {
                  final e = entries[idx];
                  return Card(
                    child: ListTile(
                      title: Text(
                        e.action.isNotEmpty ? e.action : '—',
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        "${DateFormat.yMMMd().format(e.date)} • ${e.phase} • mood ${e.mood}",
                      ),
                      trailing: Text(
                        (e.moneyIn - e.moneyOut).toStringAsFixed(2),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            Text(_motto(), style: TextStyle(color: Colors.tealAccent)),
          ],
        ),
      ),
    );
  }
}
