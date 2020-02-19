import 'package:args/args.dart';

class IssueTransitionRequest {
  final String issueKey;
  final String transitionId;

  IssueTransitionRequest({this.issueKey, this.transitionId});

  IssueTransitionRequest copyWith({
    String issueKey,
    String transitionId,
  }) {
    return IssueTransitionRequest(
      issueKey: issueKey ?? this.issueKey,
      transitionId: transitionId ?? this.transitionId,
    );
  }

  factory IssueTransitionRequest.fromArgs(ArgResults argResults) {
    return IssueTransitionRequest(
      issueKey: argResults['issueKey'] as String,
    );
  }
}
