import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), // Formes arrondies [cite: 5]
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32.0, color: color),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins', // Ou 'Montserrat' [cite: 5]
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Open Sans', // Ou 'Roboto' [cite: 5]
                fontSize: 24.0,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}