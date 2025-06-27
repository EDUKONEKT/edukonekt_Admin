import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/models/subject_model.dart';
import '../provider/subject_provider.dart';
import '../widgets/subject_detail_page.dart';
import '../widgets/subject_form_dialog.dart';
import '../widgets/subject_tile.dart';


class SubjectListPage extends StatelessWidget {
  const SubjectListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('subjects.title'.tr()),
      ),
      body: Consumer<SubjectProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.subjects.isEmpty) {
            return Center(child: Text('subjects.empty'.tr()));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.subjects.length,
            itemBuilder: (context, index) {
              final subject = provider.subjects[index];
              return SubjectTile(
                subject: subject,
                onView: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SubjectDetailPage(subject: subject),
                    ),
                  );
                },
                onEdit: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => SubjectFormDialog(subject: subject),
                  );
                },
                onDelete: () async {
                  final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('subjects.delete_confirm_title'.tr()),
                          content: Text('subjects.delete_confirm_msg'.tr(args: [subject.name])),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('common.cancel'.tr()),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text('common.delete'.tr()),
                            ),
                          ],
                        ),
                      ) ??
                      false;
                  if (confirmed) {
                    context.read<SubjectProvider>().deleteSubject(subject.id);
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const SubjectFormDialog(),
        ),
        icon: const Icon(Icons.add),
        label: Text('subjects.add'.tr()),
      ),
    );
  }
}
