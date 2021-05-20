// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that holds the document data before and after update.
class DocumentChangeData extends DataModel {
  /// A [DataModel] of a document data before the update.
  final DataModel beforeUpdateData;

  /// A [DataModel] of a document data after the update.
  final DataModel afterUpdateData;

  /// Creates a new instance of the [DocumentChangeData]
  /// with the given parameters.
  ///
  /// Throws an [ArgumentError] if either [beforeUpdateData]
  /// or [afterUpdateData] is `null`.
  DocumentChangeData({
    @required this.beforeUpdateData,
    @required this.afterUpdateData,
  }) {
    ArgumentError.checkNotNull(beforeUpdateData, 'beforeUpdateData');
    ArgumentError.checkNotNull(afterUpdateData, 'afterUpdateData');
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'before': beforeUpdateData.toJson(),
      'after': afterUpdateData.toJson(),
    };
  }
}
