import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../widget/school_setup_form.dart';

class SchoolSetupScreen extends StatelessWidget {
  const SchoolSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SchoolFee.school_setup'.tr())),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SchoolSetupForm(),
      ),
    );
  }
}
