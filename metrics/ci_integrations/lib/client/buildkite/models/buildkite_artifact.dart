// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

/// A class that represents an artifact of a Buildkite build.
class BuildkiteArtifact extends Equatable {
  /// A unique identifier of this artifact.
  final String id;

  /// A name of this artifact.
  final String filename;

  /// A URL needed to download this artifact.
  final String downloadUrl;

  /// A mime type of this artifact that indicates its nature and format.
  final String mimeType;

  /// Creates a new instance of the [BuildkiteArtifact].
  const BuildkiteArtifact({
    this.id,
    this.filename,
    this.downloadUrl,
    this.mimeType,
  });

  @override
  List<Object> get props => [id, filename, downloadUrl, mimeType];

  /// Creates a new instance of the [BuildkiteArtifact] from the decoded
  /// JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory BuildkiteArtifact.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return BuildkiteArtifact(
      id: json['id'] as String,
      filename: json['filename'] as String,
      downloadUrl: json['download_url'] as String,
      mimeType: json['mime_type'] as String,
    );
  }

  /// Creates a list of [BuildkiteArtifact] from the given [list] of decoded
  /// JSON objects.
  ///
  /// Returns `null` if the given [list] is `null`.
  static List<BuildkiteArtifact> listFromJson(List<dynamic> list) {
    return list
        ?.map(
            (json) => BuildkiteArtifact.fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  /// Converts this artifact instance into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'filename': filename,
      'download_url': downloadUrl,
      'mime_type': mimeType
    };
  }

  @override
  String toString() {
    return 'BuildkiteArtifact ${toJson()}';
  }
}
