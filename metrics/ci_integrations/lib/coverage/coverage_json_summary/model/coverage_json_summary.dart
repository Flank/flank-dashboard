import 'package:ci_integration/coverage/coverage_json_summary/model/total_covarage_summary.dart';
import 'package:equatable/equatable.dart';

/// The class that represents the project coverage JSON-summary.
class CoverageJsonSummary extends Equatable {
  /// Total summary of the project code coverage.
  final TotalCoverageSummary total;

  @override
  List<Object> get props => [total];

  /// Creates the [CoverageJsonSummary] with the given [total] summary.
  const CoverageJsonSummary({this.total});

  /// Creates [CoverageJsonSummary] from the decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory CoverageJsonSummary.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final totalSummary = json['total'] as Map<String, dynamic>;

    return CoverageJsonSummary(
      total: TotalCoverageSummary.fromJson(totalSummary),
    );
  }
}
