import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../models/synchronicity_entry.dart';

class NewSynchronicityScreen extends StatefulWidget {
  @override
  _NewSynchronicityScreenState createState() => _NewSynchronicityScreenState();
}

class _NewSynchronicityScreenState extends State<NewSynchronicityScreen> {
  final _formKey = GlobalKey<FormState>();
  String _type = "Numbers";
  String _observation = "";
  String _feeling = "";
  String _action = "";
  double _intensity = 3;
  bool _isPrimary = false;

  final List<String> _types = [
    "Numbers",
    "Coincidence",
    "Dream",
    "Nature",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text("New Synchronicity Entry")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: _types
                    .map((t) => DropdownMenuItem(child: Text(t), value: t))
                    .toList(),
                onChanged: (val) => setState(() => _type = val!),
                decoration: InputDecoration(labelText: "Type"),
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(labelText: "Observation"),
                maxLines: 3,
                onChanged: (val) => _observation = val,
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(labelText: "Feeling"),
                maxLines: 2,
                onChanged: (val) => _feeling = val,
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Action Inspired (optional)",
                ),
                maxLines: 2,
                onChanged: (val) => _action = val,
              ),
              SizedBox(height: 12),
              Text("Intensity", style: TextStyle(fontWeight: FontWeight.bold)),
              RatingBar.builder(
                initialRating: _intensity,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemBuilder: (_, __) =>
                    Icon(Icons.star, color: Colors.tealAccent),
                onRatingUpdate: (rating) => _intensity = rating,
              ),
              SizedBox(height: 12),
              CheckboxListTile(
                value: _isPrimary,
                onChanged: (val) => setState(() => _isPrimary = val!),
                title: Text(
                  "Set as primary signal of the day",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Save Entry"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    app.addSyncEntry(
                      SynchronicityEntry(
                        date: DateTime.now(),
                        type: _type,
                        observation: _observation,
                        feeling: _feeling,
                        action: _action.isEmpty ? null : _action,
                        intensity: _intensity.toInt(),
                        isPrimary: _isPrimary,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
