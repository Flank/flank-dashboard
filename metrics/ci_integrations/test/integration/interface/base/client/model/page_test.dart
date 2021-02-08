// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/client/model/page.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("Page", () {
    test(".hasNextPage is true if the given next page URL is not null", () {
      const page = _PageFake(nextPageUrl: 'page/url');

      expect(page.hasNextPage, isTrue);
    });

    test(".hasNextPage is false if the given next page URL is null", () {
      const page = _PageFake(nextPageUrl: null);

      expect(page.hasNextPage, isFalse);
    });
  });
}

/// A fake implementation of the [Page] that is used for testing.
class _PageFake extends Page {
  /// Creates a new instance of the [_PageFake].
  const _PageFake({
    int totalCount,
    int page,
    int perPage,
    String nextPageUrl,
    List values,
  }) : super(
          totalCount: totalCount,
          page: page,
          perPage: perPage,
          nextPageUrl: nextPageUrl,
          values: values,
        );
}
