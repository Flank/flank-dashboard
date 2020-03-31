/// Base class for data models.
abstract class DataModel {
  /// Converts [DataModel] into the JSON encodable [Map].
  Map<String, dynamic> toJson();
}
