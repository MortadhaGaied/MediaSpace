import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  double minPrice = 0.0;
  double maxPrice = 1000.0;
  DateTime? selectedDate;
  double numOfParticipants = 1;
  Map<String, bool> equipment = {
    'Wifi': false,
    'Projector': false,
    'Mic': false,
  };
  Map<String, bool> spaceTypes = {
    'Office': false,
    'Meeting Room': false,
    'Open Space': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Filter")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Price Range:"),
                Text("Min: \$${minPrice.toStringAsFixed(0)}, Max: \$${maxPrice.toStringAsFixed(0)}"),
              ],
            ),
            RangeSlider(
              min: 0,
              max: 1000,
              values: RangeValues(minPrice, maxPrice),
              onChanged: (RangeValues values) {
                setState(() {
                  minPrice = values.start;
                  maxPrice = values.end;
                });
              },
            ),
            Text("Select Date:"),
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != selectedDate)
                  setState(() {
                    selectedDate = picked;
                  });
              },
              child: Text(selectedDate == null
                  ? "Choose Date"
                  : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Number of Participants:"),
                Text(numOfParticipants.round().toString()),
              ],
            ),
            Slider(
              min: 1,
              max: 100,
              value: numOfParticipants,
              onChanged: (double value) {
                setState(() {
                  numOfParticipants = value;
                });
              },
            ),
            Text("Equipment:"),
            Column(
              children: equipment.keys.map((String key) {
                return CheckboxListTile(
                  title: Text(key),
                  value: equipment[key],
                  onChanged: (bool? value) {
                    setState(() {
                      equipment[key] = value!;
                    });
                  },
                );
              }).toList(),
            ),
            Text("Space Types:"),
            Column(
              children: spaceTypes.keys.map((String key) {
                return CheckboxListTile(
                  title: Text(key),
                  value: spaceTypes[key],
                  onChanged: (bool? value) {
                    setState(() {
                      spaceTypes[key] = value!;
                    });
                  },
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Apply your filters here
                  },
                  child: Text('Apply Filters'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Clear all filters here
                    setState(() {
                      minPrice = 0;
                      maxPrice = 1000;
                      selectedDate = null;
                      numOfParticipants = 1;
                      equipment.updateAll((key, value) => false);
                      spaceTypes.updateAll((key, value) => false);
                    });
                  },
                  child: Text('Clear All'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
