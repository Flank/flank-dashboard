import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/widgets/search_input_field.dart';
import 'package:metrics/dashboard/presentation/model/project_metrics_search_filter.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

/// The specific [SearchInputField] widget that searches across projects.
class ProjectSearchInput extends StatefulWidget {
  @override
  _ProjectSearchInputState createState() => _ProjectSearchInputState();
}

class _ProjectSearchInputState extends State<ProjectSearchInput> {
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
        if (_searchBehaviourSubject.value == null) return;

        _projectMetricsNotifier.addFilter(
          ProjectsSearchMetricsFilter(search: _searchBehaviourSubject.value),
        );
      },
    ).listen((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return SearchInputField(
      onChanged: (value) => _searchBehaviourSubject.add(value),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchSubscription?.cancel();
  }
}
