/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return IconButton(
      icon: Icon(isDark ? Icons.wb_sunny : Icons.nightlight_round),
      onPressed: themeProvider.toggleTheme,
    );
  }
}*/
