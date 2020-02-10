import 'package:metrics/features/dashboard/domain/entities/build.dart';
import 'package:metrics/features/dashboard/domain/entities/coverage.dart';
import 'package:metrics/features/dashboard/domain/repositories/metrics_repository.dart';

class MetricsRepositoryImpl implements MetricsRepository {
  final List<Build> _projectBuilds = [
    Build(
      startedAt: DateTime.now(),
      result: BuildResult.successful,
      duration: const Duration(minutes: 20),
      url: 'https://google.com',
    ),
    Build(
      startedAt: DateTime.now().add(const Duration(days: 1)),
      result: BuildResult.successful,
      duration: const Duration(minutes: 13),
      url: 'https://google.com',
    ),
    Build(
      startedAt: DateTime.now().add(const Duration(days: 2)),
      result: BuildResult.failed,
      duration: const Duration(minutes: 34),
      url: 'https://google.com',
    ),
    Build(
      startedAt: DateTime.now().add(const Duration(days: 3)),
      result: BuildResult.successful,
      duration: const Duration(minutes: 26),
      url: 'https://google.com',
    ),
    Build(
      startedAt: DateTime.now().add(const Duration(days: 3, hours: 2)),
      result: BuildResult.successful,
      duration: const Duration(minutes: 28),
      url: 'https://google.com',
    ),
    Build(
      startedAt: DateTime.now().add(const Duration(days: 3, hours: 5)),
      result: BuildResult.failed,
      duration: const Duration(minutes: 23),
      url: 'https://google.com',
    ),
    Build(
      startedAt: DateTime.now().add(const Duration(days: 4)),
      result: BuildResult.successful,
      duration: const Duration(minutes: 10),
      url: 'https://google.com',
    ),
    Build(
      startedAt: DateTime.now().add(const Duration(days: 5)),
      result: BuildResult.successful,
      duration: const Duration(minutes: 12),
      url: 'https://google.com',
    ),
    Build(
      startedAt: DateTime.now().add(const Duration(days: 5, hours: 3)),
      result: BuildResult.successful,
      duration: const Duration(minutes: 16),
      url: 'https://google.com',
    ),
    Build(
      startedAt: DateTime.now().add(const Duration(days: 6)),
      result: BuildResult.failed,
      duration: const Duration(minutes: 15),
      url: 'https://google.com',
    ),
    Build(
      startedAt: DateTime.now().add(const Duration(days: 7, hours: 5)),
      result: BuildResult.failed,
      duration: const Duration(minutes: 23),
      url: 'https://google.com',
    ),
    Build(
      startedAt: DateTime.now().add(const Duration(days: 8)),
      result: BuildResult.successful,
      duration: const Duration(minutes: 7),
      url: 'https://google.com',
    ),
    Build(
      startedAt: DateTime.now().add(const Duration(days: 9)),
      result: BuildResult.successful,
      duration: const Duration(minutes: 18),
      url: 'https://google.com',
    ),
    Build(
      startedAt: DateTime.now().add(const Duration(days: 9, hours: 3)),
      result: BuildResult.successful,
      duration: const Duration(minutes: 18),
      url: 'https://google.com',
    ),
    Build(
      startedAt: DateTime.now().add(const Duration(days: 10, hours: 3)),
      result: BuildResult.successful,
      duration: const Duration(minutes: 10),
      url: 'https://google.com',
    ),
    Build(
      startedAt: DateTime.now().add(const Duration(days: 11)),
      result: BuildResult.failed,
      duration: const Duration(minutes: 23),
      url: 'https://google.com',
    ),
    Build(
      startedAt: DateTime.now().add(const Duration(days: 12)),
      result: BuildResult.successful,
      duration: const Duration(minutes: 16),
      url: 'https://google.com',
    ),
    Build(
      startedAt: DateTime.now().add(const Duration(days: 12, hours: 3)),
      result: BuildResult.successful,
      duration: const Duration(minutes: 14),
      url: 'https://google.com',
    ),
  ];

  @override
  Future<Coverage> getCoverage(String projectId) {
    return Future.delayed(
      const Duration(seconds: 1),
      () => const Coverage(percent: 0.2),
    );
  }

  @override
  Future<List<Build>> getProjectBuilds(String projectId) {
    return Future.delayed(const Duration(seconds: 1), () => _projectBuilds);
  }
}
