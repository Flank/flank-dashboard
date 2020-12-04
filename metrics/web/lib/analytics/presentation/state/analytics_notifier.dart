import 'package:flutter/foundation.dart';
import 'package:metrics/analytics/domain/entities/page_name.dart';
import 'package:metrics/analytics/domain/usecases/log_login_use_case.dart';
import 'package:metrics/analytics/domain/usecases/log_page_view_use_case.dart';
import 'package:metrics/analytics/domain/usecases/parameters/page_name_param.dart';
import 'package:metrics/analytics/domain/usecases/reset_user_use_case.dart';
import 'package:metrics/common/domain/usecases/parameters/user_id_param.dart';

/// The [ChangeNotifier] that provides an ability to log user activities.
class AnalyticsNotifier extends ChangeNotifier {
  /// A [UseCase] that provides an ability to log user logins.
  final LogLoginUseCase _logLoginUseCase;

  /// A [UseCase] that provides an ability to log page changes.
  final LogPageViewUseCase _logPageViewUseCase;

  /// A [UseCase] that provides an ability to reset the user.
  final ResetUserUseCase _resetUserUseCase;

  /// A unique identifier of the user.
  String _userId;

  /// Creates a new instance of the [AnalyticsNotifier].
  ///
  /// All the parameters must not be `null`.
  AnalyticsNotifier(
    this._logLoginUseCase,
    this._logPageViewUseCase,
    this._resetUserUseCase,
  )   : assert(_logLoginUseCase != null),
        assert(_logPageViewUseCase != null),
        assert(_resetUserUseCase != null);

  /// Logs the user login with the given [userId].
  Future<void> logLogin(String userId) async {
    if (_userId == userId) return;

    _userId = userId;

    final userIdParam = UserIdParam(id: userId);

    return _logLoginUseCase(userIdParam);
  }

  /// Logs the page view with the given [name].
  Future<void> logPageView(String name) async {
    final pageName = PageName.values.firstWhere(
      (page) => page.value == name,
      orElse: () => null,
    );

    if (pageName == null) return;

    final pageNameParam = PageNameParam(pageName: pageName);

    return _logPageViewUseCase(pageNameParam);
  }

  /// Resets the user parameters.
  Future<void> resetUser() {
    return _resetUserUseCase();
  }
}
