import 'package:meta/meta.dart';

/// A class that represents the user identifier parameter.
@immutable
class UserIdParam {
  /// A user identifier.
  final String id;

  /// Creates a new instance of the [UserIdParam].
  ///
  /// The [id] must not be `null`.
  UserIdParam({@required this.id}) {
    ArgumentError.checkNotNull(id, 'id');
  }
}
