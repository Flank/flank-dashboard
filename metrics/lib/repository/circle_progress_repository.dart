import 'package:metrics/models/circle_progress_model.dart';
import 'dart:math' as math;

abstract class CircleProgressRepository {
  Future<CircleProgressModel> fetchProgressCoverage();
  Future<CircleProgressModel> fetchProgressStability();
}

class FakeCircleProgressRepository implements CircleProgressRepository {
  double valueStability;
  double valueCoverage;

  @override
  Future<CircleProgressModel> fetchProgressCoverage() {
    // Simulate network delay
    return Future.delayed(
      Duration(seconds: 1),
      () {
        

        // Simulate some network error
        // if (random.nextBool()) {
        //   throw NetworkError();
        // }

        // Since we're inside a fake repository, we need to cache the temperature
        // in order to have the same one returned in for the detailed weather

        valueCoverage = math.Random().nextDouble();

        // Return "fetched" weather
        return CircleProgressModel(
          data: valueCoverage,
        );
      },
    );
  }

  @override
  Future<CircleProgressModel> fetchProgressStability() {
    // Simulate network delay
    return Future.delayed(
      Duration(seconds: 1),
      () {
        

        // Simulate some network error
        // if (random.nextBool()) {
        //   throw NetworkError();
        // }

        // Since we're inside a fake repository, we need to cache the temperature
        // in order to have the same one returned in for the detailed weather

        valueStability = math.Random().nextDouble();

        // Return "fetched" weather
        return CircleProgressModel(
          data: valueStability,
        );
      },
    );
  }
}

class NetworkError extends Error {}
