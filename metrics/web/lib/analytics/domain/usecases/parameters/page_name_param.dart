import 'package:meta/meta.dart';
import 'package:metrics/analytics/domain/entities/page_name.dart';

/// A class that represents the page name parameter.
@immutable
class PageNameParam {
  /// A page name.
  final PageName pageName;

  /// Creates a new instance of the [PageNameParam].
  ///
  /// The [pageName] must not be `null`.
  PageNameParam({@required this.pageName}) {
    ArgumentError.checkNotNull(pageName, 'pageName');
  }
}
