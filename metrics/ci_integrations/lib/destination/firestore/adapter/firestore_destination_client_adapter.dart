// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:ci_integration/cli/logger/mixin/logger_mixin.dart';
import 'package:ci_integration/client/firestore/firestore.dart';
import 'package:ci_integration/data/deserializer/build_data_deserializer.dart';
import 'package:ci_integration/destination/error/destination_error.dart';
import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:metrics_core/metrics_core.dart';

/// A class that provides methods for interactions between
/// [CiIntegration] and Firestore destination storage.
class FirestoreDestinationClientAdapter
    with LoggerMixin
    implements DestinationClient {
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
    Map<String, dynamic> buildJson;

    try {
      logger.info('Getting a project with the project id $projectId ...');
      final project =
          await _firestore.collection('projects').document(projectId).get();

      if (!project.exists) {
        throw ArgumentError(
          'Project with the given ID $projectId is not found',
        );
      }

      final collection = _firestore.collection('build');

      logger.info('Adding ${builds.length} builds...');
      for (final build in builds) {
        final documentId = '${project.id}_${build.buildNumber}';
        final map = build.copyWith(projectId: project.id).toJson();
        buildJson = map;

        await collection.document(documentId).create(map);
        logger.info('Added build id $documentId.');
      }
    } on fd.FirestoreException catch (e) {
      if (buildJson != null) {
        logger.info('Failed to add build: $buildJson');
        buildJson = null;
      }

      throw DestinationError(message: '$e');
    }
  }

  @override
  Future<BuildData> fetchLastBuild(String projectId) async {
    logger.info('Fetching last build for the project id $projectId...');

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
    ArgumentError.checkNotNull(projectId, 'projectId');
    ArgumentError.checkNotNull(status, 'status');

    if (!await _projectExists(projectId)) {
      throw ArgumentError(
        'Project with the given ID $projectId is not found',
      );
    }

    try {
      final documents = await _firestore
          .collection('build')
          .where('projectId', isEqualTo: projectId)
          .where('buildStatus', isEqualTo: '$status')
          .getDocuments();

      return documents.map((document) {
        return BuildDataDeserializer.fromJson(document.map, document.id);
      }).toList();
    } on fd.FirestoreException catch (e) {
      throw DestinationError(message: '$e');
    }
  }

  @override
  Future<void> updateBuilds(String projectId, List<BuildData> newBuilds) async {
    ArgumentError.checkNotNull(projectId, 'projectId');
    ArgumentError.checkNotNull(newBuilds, 'newBuilds');

    if (!await _projectExists(projectId)) {
      throw ArgumentError(
        'Project with the given ID $projectId is not found',
      );
    }

    for (final newBuild in newBuilds) {
      final buildId = newBuild.id;

      final oldBuild = _firestore.collection('build').document(buildId);

      try {
        await oldBuild.update(newBuild.toJson());
      } on fd.FirestoreException catch (e) {
        throw DestinationError(
          message:
              'Failed to update the following build ${newBuild.id} with the following error: ${e.message}',
        );
      }
    }
  }

  /// Returns `true` if a project with the given [projectId] exists.
  ///
  /// Otherwise, returns `false`.
  Future<bool> _projectExists(String projectId) async {
    final project = await _firestore
        .collection(
          'projects',
        )
        .document(projectId)
        .get();

    return project.exists;
  }

  @override
  void dispose() {}
}
