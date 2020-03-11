import 'package:ci_integration/common/authorization/authorization.dart';
import 'package:ci_integration/jenkins/client/jenkins_client.dart';
import 'package:ci_integration/jenkins/model/jenkins_multi_branch_job.dart';
import 'package:ci_integration/jenkins/model/jenkins_query_limits.dart';

Future<void> main(List<String> arguments) async {
  const username = 'username';
  const password = 'password';

  final JenkinsClient client = JenkinsClient(
    jenkinsUrl: 'http://localhost:8080',
    authorization: BasicAuthorization(username, password),
  );

  final result = await client.fetchJobs(
    const JenkinsMultiBranchJob(
      name: 'Test',
      url: 'http://localhost:8080/job/Test/',
    ),
    limits: JenkinsQueryLimits.endAt(0),
  );
  print(result);

  client.close();
}
