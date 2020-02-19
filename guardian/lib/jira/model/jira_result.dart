class JiraResult<T> {
  final bool _isError;
  final String message;
  final T result;

  bool get isError => _isError;

  bool get isSuccess => !_isError;

  JiraResult._(this._isError, this.message, this.result);

  JiraResult.error({
    String message,
    T result,
  }) : this._(true, message, result);

  JiraResult.success({
    String message,
    T result,
  }) : this._(false, message, result);

  @override
  String toString() {
    return '$runtimeType { '
        'isError: $_isError, '
        'message: $message, '
        'result: $result }';
  }
}
