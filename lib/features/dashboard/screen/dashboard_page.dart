import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/utils/app_cleaner.dart';
import '../../../providers/theme_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/login_screen.dart';
import '../widgets/right_drawer.dart';

class DashboardPage extends StatelessWidget {
  final String schoolId;
  const DashboardPage({super.key, required this.schoolId});

  @override
  Widget build(BuildContext context) {
    final  authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Change Language',
            icon: const Icon(Icons.language),
            onPressed: () {
              final currentLocale = context.locale;
              final newLocale = currentLocale.languageCode == 'en'
                  ? const Locale('fr')
                  : const Locale('en');
              context.setLocale(newLocale);
            },
          ),
          IconButton(
            icon: const Icon(Icons.wb_sunny),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
          const SizedBox(width: 16),
           IconButton(
            icon : const Icon(Icons.notifications_none),
            onPressed: () {
              authProvider.signOut();
              AppCleaner.disposeAllStreams(context);
                Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginScreen(),
      ));
            },         ),
          const SizedBox(width: 16),
          const Icon(Icons.message_outlined),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
           RightDrawer(schoolId: schoolId),
          Expanded(
            child: Center(
              child: Text(
                'dashboard.stats_placeholder'.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
