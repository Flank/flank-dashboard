import 'package:metrics/analytics/domain/usecases/log_login_use_case.dart';
import 'package:metrics/analytics/domain/usecases/log_page_view_use_case.dart';
import 'package:metrics/analytics/domain/usecases/reset_user_use_case.dart';
import 'package:metrics/analytics/presentation/state/analytics_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("AnalyticsNotifier", () {
    final logLoginUseCase = LogLoginUseCaseMock();
    final logPageViewUseCase = LogPageViewUseCaseMock();
    final resetUserUseCase = ResetUserUseCaseMock();

    final analyticsNotifier = AnalyticsNotifier(
      logLoginUseCase,
      logPageViewUseCase,
      resetUserUseCase,
    );

    setUp(() {
      reset(logLoginUseCase);
      reset(logPageViewUseCase);
      reset(resetUserUseCase);
    });

    test(
      "throws an AssertionError if a log login use case parameter is null",
      () {
        expect(
          () => AnalyticsNotifier(null, logPageViewUseCase, resetUserUseCase),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if a log page view use case parameter is null",
      () {
        expect(
          () => AnalyticsNotifier(logLoginUseCase, null, resetUserUseCase),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if a reset user use case parameter is null",
      () {
        expect(
          () => AnalyticsNotifier(logLoginUseCase, logPageViewUseCase, null),
          MatcherUtil.throwsAssertionError,
        );
      },
    );
  });
}

class LogLoginUseCaseMock extends Mock implements LogLoginUseCase {}

class LogPageViewUseCaseMock extends Mock implements LogPageViewUseCase {}

class ResetUserUseCaseMock extends Mock implements ResetUserUseCase {}
