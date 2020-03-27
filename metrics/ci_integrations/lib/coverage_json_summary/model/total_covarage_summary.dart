import 'package:ci_integration/coverage_json_summary/model/coverage.dart';
import 'package:equatable/equatable.dart';

/// The class that represents the total code coverage summary of the project.
class TotalCoverageSummary extends Equatable {
  /// Coverage of the conditional statements.
  final Coverage branches;

  @override
  List<Object> get props => [branches];

  /// Creates the [TotalCoverageSummary] with the given [branches] coverage.
  const TotalCoverageSummary({this.branches});

  /// Creates [TotalCoverageSummary] from the decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory TotalCoverageSummary.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final branchesSummary = json['branches'] as Map<String, dynamic>;

    return TotalCoverageSummary(
      branches: Coverage.fromJson(branchesSummary),
    );
  }
}
