import 'package:ci_integration/common/authorization/authorization.dart';
import 'package:ci_integration/jenkins/client/jenkins_client.dart';
import 'package:ci_integration/jenkins/client/model/jenkins_query_limits.dart';

Future<void> main(List<String> arguments) async {
  const username = 'username';
  const password = 'password';

  final JenkinsClient jenkinsClient = JenkinsClient(
    url: 'http://localhost:8080',
    authorization: BasicAuthorization(username, password),
  );

  final result = await jenkinsClient.fetchJobs(
    'Test',
    limits: JenkinsQueryLimits.endAt(0),
  );
  print(result);

  jenkinsClient.close();
}
