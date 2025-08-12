// lib/widgets/checklist_widget.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/checklist_item.dart';

class ChecklistWidget extends StatefulWidget {
  const ChecklistWidget({super.key});

  @override
  State<ChecklistWidget> createState() => _ChecklistWidgetState();
}

class _ChecklistWidgetState extends State<ChecklistWidget> {
  List<ChecklistItem> _items = [];
  Map<int, bool> _checkedStates = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchChecklist();
  }

  Future<void> _fetchChecklist() async {
    const url = 'https://safai-index-backend.onrender.com/api/configurations/cleaner_config';
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final List<dynamic> descJson = body['data']['description'] ?? [];
        final items = ChecklistItem.listFromJson(descJson);

        setState(() {
          _items = items;
          _checkedStates = {for (var item in items) item.id: false};
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load data (code ${response.statusCode})';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!, style: const TextStyle(color: Colors.red)));
    }

    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return CheckboxListTile(
          title: Text(item.label),
          subtitle: Text(item.category),
          value: _checkedStates[item.id] ?? false,
          onChanged: (bool? value) {
            setState(() {
              _checkedStates[item.id] = value ?? false;
            });
          },
        );
      },
    );
  }
}
