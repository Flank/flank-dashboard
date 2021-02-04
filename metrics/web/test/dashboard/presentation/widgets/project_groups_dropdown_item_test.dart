// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/dropdown/widgets/metrics_dropdown_item.dart';
import 'package:metrics/dashboard/presentation/view_models/project_group_dropdown_item_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/project_groups_dropdown_item.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ProjectGroupsDropdownItem", () {
    testWidgets(
      "throws an AssertionError if the given project group dropdown item view model is null",
      (tester) async {
        await tester.pumpWidget(const _ProjectGroupsDropdownTestbed(
          projectGroupDropdownItemViewModel: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "delegates the project group dropdown item's name to the metrics dropdown item widget",
      (tester) async {
        const viewModel = ProjectGroupDropdownItemViewModel(
          id: 'id',
          name: 'name',
        );

        await tester.pumpWidget(const _ProjectGroupsDropdownTestbed(
          projectGroupDropdownItemViewModel: viewModel,
        ));

        final metricsDropdownItem = tester.widget<MetricsDropdownItem>(
          find.byType(MetricsDropdownItem),
        );

        expect(metricsDropdownItem.title, equals(viewModel.name));
      },
    );
  });
}

/// A testbed class required to test the [ProjectGroupsDropdownItem] widget.
class _ProjectGroupsDropdownTestbed extends StatelessWidget {
  /// The [ProjectGroupDropdownItemViewModel] instance to display.
  final ProjectGroupDropdownItemViewModel projectGroupDropdownItemViewModel;

  /// Creates an instance of this testbed
  /// with the given [projectGroupDropdownItemViewModel].
  const _ProjectGroupsDropdownTestbed({
    Key key,
    this.projectGroupDropdownItemViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ProjectGroupsDropdownItem(
          projectGroupDropdownItemViewModel: projectGroupDropdownItemViewModel,
        ),
      ),
    );
  }
}
