// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:ci_integration/cli/logger/mixin/logger_mixin.dart';
import 'package:ci_integration/client/firestore/firestore.dart';
import 'package:ci_integration/destination/error/destination_error.dart';
import 'package:ci_integration/integration/ci/ci_integration.dart';
import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:firedart/firedart.dart' hide Firestore;
import 'package:metrics_core/metrics_core.dart';

/// A class that provides methods for interactions between
/// [CiIntegration] and Firestore destination storage.
class FirestoreDestinationClientAdapter
    with LoggerMixin
    implements DestinationClient {
  /// A [Firestore] instance this adapter uses to interact with the Firestore.
  final Firestore _firestore;

  /// Creates a [FirestoreDestinationClientAdapter] instance
  /// with the given [Firestore] instance.
  ///
  /// Throws an [ArgumentError], if the given [Firestore] instance is `null`.
  FirestoreDestinationClientAdapter(this._firestore) {
    ArgumentError.checkNotNull(_firestore, 'firestore');
  }

  @override
  Future<void> addBuilds(String projectId, List<BuildData> builds) async {
    logger.info('Adding ${builds.length} builds...');

    await _throwIfProjectAbsent(projectId);

    final collection = _firestore.collection('build');
    try {
      for (final build in builds) {
        final newBuild = build.copyWith(projectId: projectId);

        final documentId = '${projectId}_${newBuild.buildNumber}';
        final documentReference = collection.document(documentId);

        await _addBuild(documentReference, newBuild);

        logger.info('Added build id $documentId.');
      }
    } catch (error) {
      throw DestinationError(
        message: 'Failed to add new builds with the following error: $error.',
      );
    }
  }

  /// Adds a new [build] using the given [documentReference].
  ///
  /// If the given [build] is [BuildStatus.inProgress], adds it using the
  /// [DocumentReference.create] method. Otherwise, uses the
  /// [DocumentReference.set] method.
  Future<void> _addBuild(
    DocumentReference documentReference,
    BuildData build,
  ) {
    final buildJson = build.toJson();

    if (build.buildStatus == BuildStatus.inProgress) {
      return documentReference.create(buildJson).catchError((error) {
        _handleCreateBuildError(error, buildJson);
      });
    }

    return documentReference.set(buildJson);
  }

  /// Handles the given [error] occurred during creating a build with the
  /// given [buildJson].
  ///
  /// Ignores the given [error] if it satisfies the [_isAlreadyExistsError]
  /// method. Otherwise, throws the given [error].
  void _handleCreateBuildError(
    Object error,
    Map<String, dynamic> buildJson,
  ) {
    if (_isAlreadyExistsError(error)) {
      logger.info('The build $buildJson already exists. Skipping this build.');

      return;
    }

    logger.info('Failed to add build: $buildJson');
    throw error;
  }

  /// Returns `true` if the given [error] is a [FirestoreException] having
  /// the [FirestoreExceptionCode.alreadyExists]. Otherwise, returns
  /// `false`.
  bool _isAlreadyExistsError(Object error) {
    return error is FirestoreException &&
        error.code == FirestoreExceptionCode.alreadyExists;
  }

  @override
  Future<BuildData> fetchLastBuild(String projectId) async {
    logger.info('Fetching last build for the project id $projectId...');

    await _throwIfProjectAbsent(projectId);

    final documents = await _firestore
        .collection('build')
        .where('projectId', isEqualTo: projectId)
        .orderBy('startedAt', descending: true)
        .limit(1)
        .getDocuments();

    if (documents.isEmpty) return null;

    final document = documents.first;
    return BuildDataDeserializer.fromJson(document.map, document.id);
  }

  @override
  Future<List<BuildData>> fetchBuildsWithStatus(
    String projectId,
    BuildStatus status,
  ) async {
    logger.info(
      'Fetching builds for the project id $projectId with status $status...',
    );

    ArgumentError.checkNotNull(status, 'status');

    await _throwIfProjectAbsent(projectId);

    try {
      final documents = await _firestore
          .collection('build')
          .where('projectId', isEqualTo: projectId)
          .where('buildStatus', isEqualTo: '$status')
          .getDocuments();

      return documents.map((document) {
        return BuildDataDeserializer.fromJson(document.map, document.id);
      }).toList();
    } on FirestoreException catch (error) {
      throw DestinationError(message: error.message);
    }
  }

  @override
  Future<void> updateBuilds(String projectId, List<BuildData> builds) async {
    logger.info('Updating builds for the project id $projectId...');

    ArgumentError.checkNotNull(builds, 'builds');

    await _throwIfProjectAbsent(projectId);

    for (final build in builds) {
      final buildData = build.copyWith(projectId: projectId).toJson();
      final buildId = build.id;

      final reference = _firestore.document('build/$buildId');

      await reference
          .update(buildData)
          .catchError((error) => _handleBuildUpdateError(build, error));
    }
  }

  /// Handles the given [error] occurred during updating the given [build].
  void _handleBuildUpdateError(BuildData build, Object error) {
    logger.info(
      'Failed to update the following build ${build.id} with the following error: $error',
    );
  }

  /// Checks if a project with the given [projectId] exists.
  ///
  /// Throws an [ArgumentError] if a project with the given [projectId]
  /// does not exist.
  Future<void> _throwIfProjectAbsent(String projectId) async {
    final projectExists = await _projectExists(projectId);

    if (!projectExists) {
      throw ArgumentError(
        'A project with the given ID $projectId is not found',
      );
    }
  }

  /// Returns `true` if a project with the given [projectId] exists. Otherwise,
  /// returns `false`.
  ///
  /// Throws a [DestinationError] if fetching a project with the given
  /// [projectId] fails.
  Future<bool> _projectExists(String projectId) async {
    try {
      logger.info(
        'Checking a project with the project id $projectId exists...',
      );

      final project = await _firestore.document('projects/$projectId').get();

      return project.exists;
    } on FirestoreException catch (error) {
      throw DestinationError(
        message:
            'Failed to fetch a project with the $projectId id due to the following error: ${error.message}',
      );
    }
  }

  @override
  void dispose() {}
}
