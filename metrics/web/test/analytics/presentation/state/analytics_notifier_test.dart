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

    test(
      ".logLogin() does not call the use case if the given user id is the same as in the notifier",
      () async {},
    );

    test(
      ".logLogin() delegates to the log login use case",
      () async {
        const userId = 'id';
        await analyticsNotifier.logLogin(userId);

        verify(logLoginUseCase(any)).called(1);
      },
    );

    test(
      ".logPageView() does not call the use case if the given page name is not from list",
      () async {
        const pageName = '/test';
        await analyticsNotifier.logPageView(pageName);

        verifyNever(logPageViewUseCase(any));
      },
    );

    test(
      ".logPageView() delegates to the log page view use case",
      () async {
        const pageName = '/dashboard';
        await analyticsNotifier.logPageView(pageName);

        verify(logPageViewUseCase(any)).called(1);
      },
    );

    test(
      ".resetUser() delegates to the reset user use case",
      () async {
        await analyticsNotifier.resetUser();

        verify(resetUserUseCase(any)).called(1);
      },
    );
  });
}

class LogLoginUseCaseMock extends Mock implements LogLoginUseCase {}

class LogPageViewUseCaseMock extends Mock implements LogPageViewUseCase {}

class ResetUserUseCaseMock extends Mock implements ResetUserUseCase {}
