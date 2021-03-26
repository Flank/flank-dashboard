// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/finished_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/in_progress_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_duration_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';
import 'package:clock/clock.dart';

void main() {
  group("BuildResultDurationStrategy", () {
    const buildStatus = BuildStatus.unknown;
    const duration = Duration.zero;
    const strategy = BuildResultDurationStrategy();

    final date = DateTime(2021);
    final buildResultPopupViewModel = BuildResultPopupViewModel(
      duration: duration,
      date: date,
    );
    final finishedBuildViewModel = FinishedBuildResultViewModel(
      duration: duration,
      date: date,
      buildResultPopupViewModel: buildResultPopupViewModel,
      buildStatus: buildStatus,
    );
    final inProgressBuildResultViewModel = InProgressBuildResultViewModel(
      date: date,
      buildResultPopupViewModel: buildResultPopupViewModel,
    );

    test(
      ".getDuration() returns the duration of the given build result view model if it is finished",
      () {
        final result = strategy.getDuration(finishedBuildViewModel);

        expect(result, equals(duration));
      },
    );

    test(
      ".getDuration() returns the duration of the given build result view model if it is in progress",
      () {
        final currentTime = DateTime(2022);

        withClock(Clock.fixed(currentTime), () {
          final expectedResult = currentTime.difference(
            inProgressBuildResultViewModel.date,
          );

          final result = strategy.getDuration(inProgressBuildResultViewModel);

          expect(result, equals(expectedResult));
        });
      },
    );
  });
}
