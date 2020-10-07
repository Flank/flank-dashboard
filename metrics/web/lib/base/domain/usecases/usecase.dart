/// A base class for all use cases.
abstract class UseCase<Type, Params> {
  /// A base method to invoke this use case with the given [params].
  Type call(Params params);
}
