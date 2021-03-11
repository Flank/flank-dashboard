// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/firestore/mappers/firebase_grpc_error_reason_mapper.dart';
import 'package:ci_integration/client/firestore/model/firebase_grpc_error_reason.dart';
import 'package:test/test.dart';

void main() {
  group("FirebaseGrpcErrorReasonMapper", () {
    const mapper = FirebaseGrpcErrorReasonMapper();

    test(
      ".map() maps the consumer invalid grpc error reason to FirebaseGrpcErrorReason.consumerInvalid",
      () {
        const expectedReason = FirebaseGrpcErrorReason.consumerInvalid;

        final reason =
            mapper.map(FirebaseGrpcErrorReasonMapper.consumerInvalid);

        expect(reason, equals(expectedReason));
      },
    );

    test(
      ".map() maps the not found grpc error reason to FirebaseGrpcErrorReason.notFound",
      () {
        const expectedReason = FirebaseGrpcErrorReason.notFound;

        final reason = mapper.map(FirebaseGrpcErrorReasonMapper.notFound);

        expect(reason, equals(expectedReason));
      },
    );

    test(
      ".map() returns null if the given value does not match any FirebaseGrpcErrorReason value",
      () {
        final reason = mapper.map('test');

        expect(reason, isNull);
      },
    );

    test(
      ".map() maps the null grpc error reason to null",
      () {
        final reason = mapper.map(null);

        expect(reason, isNull);
      },
    );

    test(
      ".unmap() unmaps the FirebaseGrpcErrorReason.consumerInvalid to the consumer invalid grpc error reason",
      () {
        const expectedReason = FirebaseGrpcErrorReasonMapper.consumerInvalid;

        final reason = mapper.unmap(FirebaseGrpcErrorReason.consumerInvalid);

        expect(reason, equals(expectedReason));
      },
    );

    test(
      ".unmap() unmaps the FirebaseGrpcErrorReason.notFound to the not found grpc error reason",
      () {
        const expectedReason = FirebaseGrpcErrorReasonMapper.notFound;

        final reason = mapper.unmap(FirebaseGrpcErrorReason.notFound);

        expect(reason, equals(expectedReason));
      },
    );

    test(
      ".unmap() unmaps null grpc error reason to null",
      () {
        final reason = mapper.unmap(null);

        expect(reason, isNull);
      },
    );
  });
}
