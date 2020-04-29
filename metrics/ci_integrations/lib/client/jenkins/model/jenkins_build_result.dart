import 'package:ci_integration/client/jenkins/model/jenkins_build.dart';

/// The result of [JenkinsBuild].
enum JenkinsBuildResult { aborted, notBuild, failure, unstable, success }
