// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:clock/clock.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/finished_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/in_progress_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_duration_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("BuildResultDurationStrategy", () {
    const buildStatus = BuildStatus.unknown;
    const duration = Duration.zero;
    const maxBuildDuration = Duration(days: 365);
    const strategy = BuildResultDurationStrategy();

    final date = DateTime(2021);
    final currentDateTime = DateTime(2022);
    final buildResultPopupViewModel = BuildResultPopupViewModel(
      duration: duration,
      date: date,
    );

    FinishedBuildResultViewModel createFinishedViewModel(Duration duration) {
      return FinishedBuildResultViewModel(
        duration: duration,
        date: date,
        buildResultPopupViewModel: buildResultPopupViewModel,
        buildStatus: buildStatus,
      );
    }

    InProgressBuildResultViewModel createInProgressViewModel(DateTime date) {
      return InProgressBuildResultViewModel(
        buildResultPopupViewModel: buildResultPopupViewModel,
        date: date,
      );
    }

    final finishedBuildViewModel = createFinishedViewModel(duration);
    final inProgressBuildResultViewModel = createInProgressViewModel(date);

    test(
      ".getDuration() returns the duration of the given finished build result view model if the max build duration is not specified",
      () {
        final expectedDuration = finishedBuildViewModel.duration;

        final duration = strategy.getDuration(finishedBuildViewModel);

        expect(duration, equals(expectedDuration));
      },
    );

    test(
      ".getDuration() returns the duration of the given finished build result view model if its duration is less than the max build duration",
      () {
        final expectedDuration = finishedBuildViewModel.duration;

        final duration = strategy.getDuration(
          finishedBuildViewModel,
          maxBuildDuration: maxBuildDuration,
        );

        expect(duration, equals(expectedDuration));
      },
    );

    test(
      ".getDuration() returns the max build duration if the given finished build result view model's duration is greater than the max build duration",
      () {
        final viewModel = createFinishedViewModel(maxBuildDuration * 2);

        final duration = strategy.getDuration(
          viewModel,
          maxBuildDuration: maxBuildDuration,
        );

        expect(duration, equals(maxBuildDuration));
      },
    );

    test(
      ".getDuration() returns the difference between the current time and the build date if the given build result view model is in progress and the max build duration is not specified",
      () {
        final expectedDuration = currentDateTime.difference(
          inProgressBuildResultViewModel.date,
        );

        withClock(Clock.fixed(currentDateTime), () {
          final duration = strategy.getDuration(inProgressBuildResultViewModel);

          expect(duration, equals(expectedDuration));
        });
      },
    );

    test(
      ".getDuration() returns the difference between the current time and the build date if the given build result view model is in progress and the resulting build duration is less than the max build duration",
      () {
        final buildDate = currentDateTime.subtract(maxBuildDuration ~/ 2);
        final viewModel = createInProgressViewModel(buildDate);
        final expectedDuration = currentDateTime.difference(viewModel.date);

        withClock(Clock.fixed(currentDateTime), () {
          final duration = strategy.getDuration(
            viewModel,
            maxBuildDuration: maxBuildDuration,
          );

          expect(duration, equals(expectedDuration));
        });
      },
    );

    test(
      ".getDuration() returns the max build duration if the given build result view model is in progress and the resulting build duration greater than the max build duration",
      () {
        final buildDate = currentDateTime.subtract(maxBuildDuration * 2);
        final viewModel = createInProgressViewModel(buildDate);

        withClock(Clock.fixed(currentDateTime), () {
          final duration = strategy.getDuration(
            viewModel,
            maxBuildDuration: maxBuildDuration,
          );

          expect(duration, equals(maxBuildDuration));
        });
      },
    );
  });
}
