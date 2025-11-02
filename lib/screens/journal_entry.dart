import 'package:flutter/material.dart';
import 'package:ibs_sacred_tech_flow/app_state.dart';
import 'package:ibs_sacred_tech_flow/models/synchronicity_entry.dart';
import 'package:provider/provider.dart';
import '../models/lunar_entry.dart';
import '../utils/lunar.dart';
import '../main.dart';

class JournalEntryScreen extends StatefulWidget {
  @override
  _JournalEntryScreenState createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  int mood = 7;
  List<String> gratitude = ['', '', ''];
  String energyTone = 'Focused';
  String action = '';
  double moneyIn = 0;
  double moneyOut = 0;
  String synch = '';
  String dream = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Lunar Entry')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ListTile(
                title: Text('Date'),
                subtitle: Text('${date.toLocal()}'.split(' ')[0]),
                trailing: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (d != null) setState(() => date = d);
                  },
                ),
              ),
              SizedBox(height: 8),
              Text('Mood (${mood})'),
              Slider(
                value: mood.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                onChanged: (v) => setState(() => mood = v.round()),
              ),
              SizedBox(height: 8),
              Text('Gratitude (3)'),
              for (var i = 0; i < 3; i++)
                TextFormField(
                  initialValue: gratitude[i],
                  decoration: InputDecoration(labelText: 'Gratitude ${i + 1}'),
                  onChanged: (v) => gratitude[i] = v,
                ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: energyTone,
                items: ['Calm', 'Focused', 'Inspired', 'Tired']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => energyTone = v ?? 'Focused'),
                decoration: InputDecoration(labelText: 'Energy Tone'),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Action (what you created)',
                ),
                onChanged: (v) => action = v,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Money In'),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (v) => moneyIn = double.tryParse(v) ?? 0,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Money Out'),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (v) => moneyOut = double.tryParse(v) ?? 0,
                    ),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Synchronicity / Signs'),
                onChanged: (v) => synch = v,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Dream / Intuition'),
                onChanged: (v) => dream = v,
              ),
              SizedBox(height: 12),
              ElevatedButton(
                child: Text('Save'),
                onPressed: () {
                  final phase = LunarPhase.phaseName(date);
                  final entry = LunarEntry(
                    date: date,
                    phase: phase,
                    mood: mood,
                    gratitude: gratitude
                        .where((s) => s.trim().isNotEmpty)
                        .toList(),
                    energyTone: energyTone,
                    action: action,
                    moneyIn: moneyIn,
                    moneyOut: moneyOut,
                    synchronicity: synch,
                    dream: dream,
                  );
                  Provider.of<AppState>(
                    context,
                    listen: false,
                  ).addSyncEntry(entry as SynchronicityEntry);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
