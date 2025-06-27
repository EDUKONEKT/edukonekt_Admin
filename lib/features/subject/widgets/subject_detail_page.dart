import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/models/subject_model.dart';

class SubjectDetailPage extends StatelessWidget {
  final Subject subject;

  const SubjectDetailPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('subject_detail'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subject.name, style: textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('${'code'.tr()}: ${subject.code}', style: textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text('${'description'.tr()}:', style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(subject.description, style: textTheme.bodyMedium),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Text('${'last_updated'.tr()}: ${DateFormat.yMMMd().format(subject.updatedAt)}',
                  style: textTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
  }
}
