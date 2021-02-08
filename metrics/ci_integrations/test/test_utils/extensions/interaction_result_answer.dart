// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:mockito/mockito.dart';

extension InteractionResultAnswer<T>
    on PostExpectation<FutureOr<InteractionResult<T>>> {
  void thenSuccessWith(T result, [String message]) {
    return thenAnswer(
      (_) => Future.value(
        InteractionResult<T>.success(
          message: message,
          result: result,
        ),
      ),
    );
  }

  void thenErrorWith([T result, String message]) {
    return thenAnswer(
      (_) => Future.value(
        InteractionResult<T>.error(
          result: result,
          message: message,
        ),
      ),
    );
  }
}
