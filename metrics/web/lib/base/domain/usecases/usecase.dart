/// A base class for all use cases.
abstract class UseCase<Type, Params> {
  /// A base method to invoke the use case.
  Type call(Params params);
}
