// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/mapper/jenkins_build_result_mapper.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build_result.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsBuildResultMapper", () {
    const resultMapper = JenkinsBuildResultMapper();

    test(".map() maps the aborted result to JenkinsBuildResult", () {
      final result = resultMapper.map(JenkinsBuildResultMapper.aborted);
      const expected = JenkinsBuildResult.aborted;

      expect(result, equals(expected));
    });

    test(".map() maps the not built result to JenkinsBuildResult", () {
      final result = resultMapper.map(JenkinsBuildResultMapper.notBuilt);
      const expected = JenkinsBuildResult.notBuild;

      expect(result, equals(expected));
    });

    test(".map() maps the failure result to JenkinsBuildResult", () {
      final result = resultMapper.map(JenkinsBuildResultMapper.failure);
      const expected = JenkinsBuildResult.failure;

      expect(result, equals(expected));
    });

    test(".map() maps the success result to JenkinsBuildResult", () {
      final result = resultMapper.map(JenkinsBuildResultMapper.success);
      const expected = JenkinsBuildResult.success;

      expect(result, equals(expected));
    });

    test(".map() maps the unstable result to JenkinsBuildResult", () {
      final result = resultMapper.map(JenkinsBuildResultMapper.unstable);
      const expected = JenkinsBuildResult.unstable;

      expect(result, equals(expected));
    });

    test(".map() maps the not specified result to null", () {
      final result = resultMapper.map("TEST");

      expect(result, isNull);
    });

    test(".map() maps the null result to null", () {
      final result = resultMapper.map(null);

      expect(result, isNull);
    });

    test(".unmap() unmaps the JenkinsBuildResult.aborted", () {
      final result = resultMapper.unmap(JenkinsBuildResult.aborted);
      const expected = JenkinsBuildResultMapper.aborted;

      expect(result, equals(expected));
    });

    test(".unmap() unmaps the JenkinsBuildResult.notBuild", () {
      final result = resultMapper.unmap(JenkinsBuildResult.notBuild);
      const expected = JenkinsBuildResultMapper.notBuilt;

      expect(result, equals(expected));
    });

    test(".unmap() unmaps the JenkinsBuildResult.failure", () {
      final result = resultMapper.unmap(JenkinsBuildResult.failure);
      const expected = JenkinsBuildResultMapper.failure;

      expect(result, equals(expected));
    });

    test(".unmap() unmaps the JenkinsBuildResult.success", () {
      final result = resultMapper.unmap(JenkinsBuildResult.success);
      const expected = JenkinsBuildResultMapper.success;

      expect(result, equals(expected));
    });

    test(".unmap() unmaps the JenkinsBuildResult.unstable", () {
      final result = resultMapper.unmap(JenkinsBuildResult.unstable);
      const expected = JenkinsBuildResultMapper.unstable;

      expect(result, equals(expected));
    });

    test(".unmap() unmaps the null to null", () {
      final result = resultMapper.unmap(JenkinsBuildResult.notBuild);
      const expected = JenkinsBuildResultMapper.notBuilt;

      expect(result, equals(expected));
    });
  });
}
