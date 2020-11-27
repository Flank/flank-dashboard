import 'package:metrics/analytics/domain/repositories/analytics_repository.dart';
import 'package:metrics/analytics/domain/usecases/parameters/user_id_param.dart';
import 'package:metrics/base/domain/usecases/usecase.dart';

/// A [UseCase] that provides an ability to log user logins.
class LogLoginUseCase implements UseCase<Future<void>, UserIdParam> {
  /// A [AnalyticsRepository] that provides an ability to interact
  /// with the store.
  final AnalyticsRepository _repository;

  /// Creates a [LogLoginUseCase] with the given [AnalyticsRepository].
  const LogLoginUseCase(this._repository) : assert(_repository != null);

  @override
  Future<void> call(UserIdParam params) {
    return _repository.logLogin(params.id);
  }
}
