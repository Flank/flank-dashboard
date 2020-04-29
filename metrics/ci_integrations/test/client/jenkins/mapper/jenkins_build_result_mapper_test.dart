import 'package:ci_integration/client/jenkins/mapper/jenkins_build_result_mapper.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_build_result.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsBuildResultMapper", () {
    const resultMapper = JenkinsBuildResultMapper();

    test(".map() should map the aborted result to JenkinsBuildResult", () {
      final result = resultMapper.map(JenkinsBuildResultMapper.aborted);
      const expected = JenkinsBuildResult.aborted;

      expect(result, equals(expected));
    });

    test(".map() should map the not built result to JenkinsBuildResult", () {
      final result = resultMapper.map(JenkinsBuildResultMapper.notBuilt);
      const expected = JenkinsBuildResult.notBuild;

      expect(result, equals(expected));
    });

    test(".map() should map the failure result to JenkinsBuildResult", () {
      final result = resultMapper.map(JenkinsBuildResultMapper.failure);
      const expected = JenkinsBuildResult.failure;

      expect(result, equals(expected));
    });

    test(".map() should map the success result to JenkinsBuildResult", () {
      final result = resultMapper.map(JenkinsBuildResultMapper.success);
      const expected = JenkinsBuildResult.success;

      expect(result, equals(expected));
    });

    test(".map() should map the unstable result to JenkinsBuildResult", () {
      final result = resultMapper.map(JenkinsBuildResultMapper.unstable);
      const expected = JenkinsBuildResult.unstable;

      expect(result, equals(expected));
    });

    test(".map() should map the not specified result to null", () {
      final result = resultMapper.map("TEST");

      expect(result, isNull);
    });

    test(".map() should map the null result to null", () {
      final result = resultMapper.map(null);

      expect(result, isNull);
    });

    test(".unmap() should unmap the JenkinsBuildResult.aborted", () {
      final result = resultMapper.unmap(JenkinsBuildResult.aborted);
      const expected = JenkinsBuildResultMapper.aborted;

      expect(result, equals(expected));
    });

    test(".unmap() should unmap the JenkinsBuildResult.notBuild", () {
      final result = resultMapper.unmap(JenkinsBuildResult.notBuild);
      const expected = JenkinsBuildResultMapper.notBuilt;

      expect(result, equals(expected));
    });

    test(".unmap() should unmap the JenkinsBuildResult.failure", () {
      final result = resultMapper.unmap(JenkinsBuildResult.failure);
      const expected = JenkinsBuildResultMapper.failure;

      expect(result, equals(expected));
    });

    test(".unmap() should unmap the JenkinsBuildResult.success", () {
      final result = resultMapper.unmap(JenkinsBuildResult.success);
      const expected = JenkinsBuildResultMapper.success;

      expect(result, equals(expected));
    });

    test(".unmap() should unmap the JenkinsBuildResult.unstable", () {
      final result = resultMapper.unmap(JenkinsBuildResult.unstable);
      const expected = JenkinsBuildResultMapper.unstable;

      expect(result, equals(expected));
    });

    test(".unmap() should unmap the null to null", () {
      final result = resultMapper.unmap(JenkinsBuildResult.notBuild);
      const expected = JenkinsBuildResultMapper.notBuilt;

      expect(result, equals(expected));
    });
  });
}
