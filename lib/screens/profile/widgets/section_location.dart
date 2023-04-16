import 'package:flutter/material.dart';

class LocationSection extends StatelessWidget {
  final String location;

  const LocationSection({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return _buildLocationSection();
  }

  Widget _buildLocationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          const Text(
            "Localisation",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            location,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
