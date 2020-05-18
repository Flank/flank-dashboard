import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/dashboard/presentation/model/project_metrics_search_filter.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

class SearchInput extends StatefulWidget {
  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final TextEditingController searchController = TextEditingController();
  final BehaviorSubject<String> searchBehaviourSubject =
      BehaviorSubject<String>();
  StreamSubscription _searchSubscription;

  @override
  void initState() {
    super.initState();
    final ProjectMetricsNotifier projectMetricsNotifier =
        Provider.of<ProjectMetricsNotifier>(context, listen: false);
    _searchSubscription = searchBehaviourSubject.timeout(
      const Duration(milliseconds: 300),
      onTimeout: (event) {
        if (searchController.text == null) return;
        projectMetricsNotifier.addFilter(
          ProjectsSearchMetricsFilter(
            search: searchController.text,
          ),
        );
      },
    ).listen((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return TextField(
      controller: searchController,
      onChanged: (value) {
        searchBehaviourSubject.add(searchController.text);
      },
      decoration: InputDecoration(
        fillColor: themeNotifier.isDark ? Colors.black : Colors.grey[200],
        filled: true,
        prefixIcon: const Icon(Icons.search),
        hintText: 'Search for project...',
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchSubscription?.cancel();
  }
}
