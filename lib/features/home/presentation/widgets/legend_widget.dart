import 'package:flutter/material.dart';

class Legend extends StatelessWidget {
  final List<LegendItem> items;

  Legend({required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                color: item.color,
              ),
              SizedBox(width: 4),
              Text(item.label),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class LegendItem {
  final Color color;
  final String label;

  LegendItem({required this.color, required this.label});
}