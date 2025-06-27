import 'package:flutter/material.dart';

import '../../../core/models/teacher_model.dart';

class TeacherSearchDelegate extends SearchDelegate<String?> {
  final List<Teacher> initialList;
  TeacherSearchDelegate({required this.initialList}) {
    query = '';
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = initialList.where((t) =>
      t.fullName.toLowerCase().contains(query.toLowerCase()) ||
      t.email.toLowerCase().contains(query.toLowerCase()) ||
      t.phone.contains(query)).toList();

    return ListView(
      children: results.map((t) => ListTile(
        title: Text(t.fullName),
        subtitle: Text(t.email),
        onTap: () => close(context, t.id),
      )).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}
