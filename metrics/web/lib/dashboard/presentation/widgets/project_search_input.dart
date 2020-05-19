import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

/// Display a custom [TextField] with ability to search across projects.
class ProjectSearchInput extends StatefulWidget {
  @override
  _ProjectSearchInputState createState() => _ProjectSearchInputState();
}

class _ProjectSearchInputState extends State<ProjectSearchInput> {
  final TextEditingController _searchController = TextEditingController();
  final BehaviorSubject<String> _searchBehaviourSubject =
      BehaviorSubject<String>();
  StreamSubscription _searchSubscription;

  @override
  void initState() {
    super.initState();
    final ProjectMetricsNotifier _projectMetricsNotifier =
        Provider.of<ProjectMetricsNotifier>(context, listen: false);

    _searchSubscription = _searchBehaviourSubject.timeout(
      const Duration(milliseconds: 300),
      onTimeout: (_) {
        if (_searchController.text == null) return;

        _projectMetricsNotifier.filterByProjectName(_searchController.text);
      },
    ).listen((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      onChanged: (value) => _searchBehaviourSubject.add(_searchController.text),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: CommonStrings.searchForProject,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchSubscription?.cancel();
  }
}
