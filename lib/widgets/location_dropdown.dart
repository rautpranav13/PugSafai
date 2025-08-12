import 'package:flutter/material.dart';
import '../models/location.dart';
import '../services/api_services.dart';

class LocationDropdown extends StatefulWidget {
  final String? filterTypeId; // Optional filter for type_id
  final void Function(Location?) onChanged;
  final Location? initialValue;

  const LocationDropdown({
    super.key,
    this.filterTypeId,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<LocationDropdown> createState() => _LocationDropdownState();
}

class _LocationDropdownState extends State<LocationDropdown> {
  List<Location> _locations = [];
  Location? _selectedLocation;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialValue;
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final locations = await ApiService.getLocations();

      // Apply filter if provided
      final filtered = widget.filterTypeId != null
          ? locations.where((loc) => loc.typeId == widget.filterTypeId).toList()
          : locations;

      setState(() {
        _locations = filtered;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load locations';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Row(
        children: [
          Text(_error!, style: const TextStyle(color: Colors.red)),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchLocations,
          ),
        ],
      );
    }

    if (_locations.isEmpty) {
      return const Text('No locations found');
    }

    return DropdownButton<Location>(
      value: _selectedLocation,
      isExpanded: true,
      hint: const Text("Select Location"),
      items: _locations.map((loc) {
        return DropdownMenuItem<Location>(
          value: loc,
          child: Text(loc.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedLocation = value;
        });
        widget.onChanged(value);
      },
    );
  }
}
