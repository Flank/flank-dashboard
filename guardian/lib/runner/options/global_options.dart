// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

class GlobalOptions {
  static final _instance = GlobalOptions._();

  factory GlobalOptions() {
    return _instance ?? GlobalOptions._();
  }

  GlobalOptions._();

  bool enableStackTrace;
}
