// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics/analytics/domain/entities/page_name.dart';

/// A class that represents the page name parameter.
class PageNameParam extends Equatable {
  /// A name of the page.
  final PageName pageName;

  @override
  List<Object> get props => [pageName];

  /// Creates a new instance of the [PageNameParam].
  ///
  /// The [pageName] must not be `null`.
  PageNameParam({@required this.pageName}) {
    ArgumentError.checkNotNull(pageName, 'pageName');
  }
}
