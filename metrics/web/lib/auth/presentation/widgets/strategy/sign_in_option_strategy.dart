import 'package:metrics/auth/presentation/state/auth_notifier.dart';

/// An abstract class for a strategy that provides configurations
/// for a sign in option.
abstract class SignInOptionStrategy {
  /// A label of the sign in option this strategy provides.
  String get label;

  /// An asset to use for the sign in option this strategy provides.
  String get asset;

  /// Starts a sign in process using the given [notifier].
  void signIn(AuthNotifier notifier);
}
