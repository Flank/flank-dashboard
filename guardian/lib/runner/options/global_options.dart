class GlobalOptions {
  static final _instance = GlobalOptions._();

  factory GlobalOptions() {
    return _instance ?? GlobalOptions._();
  }

  GlobalOptions._();

  bool enableStackTrace;
}
