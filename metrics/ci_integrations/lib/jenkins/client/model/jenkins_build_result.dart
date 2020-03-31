import 'package:ci_integration/jenkins/client/model/jenkins_build.dart';

/// The result of [JenkinsBuild].
enum JenkinsBuildResult { aborted, notBuild, failure, unstable, success }
