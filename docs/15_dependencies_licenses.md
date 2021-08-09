# Dependencies licenses

> Summary of the proposed change

Combine license document(s) for all components in monorepo in one document.

# References
> Link to supporting documentation, GitHub tickets, etc.

- [Software license](https://en.wikipedia.org/wiki/Software_license)
- [Dart package dependencies](https://dart.dev/tools/pub/dependencies)

# Motivation
> What problem is this project solving?

Quickly find a dependency and license of this dependency used in a Metrics component.

# Goals
> Identify success metrics and measurable goals.

* Provide a list of dependencies we use in different Metrics components.
* Provide information about a license of each dependency.

# Non-Goals
> Identify what's not in scope.

The list of dependencies for the Third Party API is out of the scope.

# Table of licenses

Each Metrics component contains a list of dependencies like plugins, packages, etc. The following subsections provide tables
 of licenses of such dependencies for each component.

## [CI Integrations](https://github.com/Flank/flank-dashboard/tree/master/metrics/ci_integrations)

| Name | Source | License |
| :---: | :---: | :---: |
| args  | [pub.dev](https://pub.dev/packages/args) | [BSD](https://github.com/dart-lang/args/blob/master/LICENSE) |
| http | [pub.dev](https://pub.dev/packages/http) | [BSD](https://github.com/dart-lang/http/blob/master/LICENSE) |
| meta | [pub.dev](https://pub.dev/packages/meta) | [BSD](https://github.com/dart-lang/sdk/blob/master/pkg/meta/LICENSE) |
| equatable | [pub.dev](https://pub.dev/packages/equatable) | [MIT](https://github.com/felangel/equatable/blob/master/LICENSE) |
| archive | [pub.dev](https://pub.dev/packages/archive) | [Apache 2.0](https://github.com/brendan-duncan/archive/blob/master/LICENSE) |
| firedart | [pub.dev](https://pub.dev/packages/firedart) | [Apache 2.0](https://github.com/cachapa/firedart/blob/master/LICENSE) |
| intl | [pub.dev](https://pub.dev/packages/intl) | [BSD](https://github.com/dart-lang/intl/blob/master/LICENSE) |

### Dev dependencies
| Name | Source | License |
| :---: | :---: | :---: |
| lint | [pub.dev](https://pub.dev/packages/lint) | [Apache 2.0](https://github.com/passsy/dart-lint/blob/master/LICENSE) |
| test | [pub.dev](https://pub.dev/packages/test) | [BSD](https://github.com/dart-lang/test/blob/master/pkgs/test/LICENSE) |
| mockito | [pub.dev](https://pub.dev/packages/mockito) | [Apache 2.0](https://github.com/dart-lang/mockito/blob/master/LICENSE) |	
| coverage | [pub.dev](https://pub.dev/packages/coverage) | [Apache 2.0](https://github.com/dart-lang/coverage/blob/master/LICENSE) |
| test_coverage| [pub.dev](https://pub.dev/packages/test_coverage) | [BSD](https://github.com/pulyaevskiy/test-coverage/blob/master/LICENSE) |

## [Core](https://github.com/Flank/flank-dashboard/tree/master/metrics/core)

| Name | Source | License |
| :---: | :---: | :---: |
| meta | [pub.dev](https://pub.dev/packages/meta) | [BSD](https://github.com/dart-lang/sdk/blob/master/pkg/meta/LICENSE) |
| equatable | [pub.dev](https://pub.dev/packages/equatable) | [MIT](https://github.com/felangel/equatable/blob/master/LICENSE) |
| email_validator | [pub.dev](https://pub.dev/packages/email_validator) | [MIT](https://github.com/fredeil/email-validator.dart/blob/master/LICENSE) |

### Dev dependencies
| Name | Source | License |
| :---: | :---: | :---: |	
| lint | [pub.dev](https://pub.dev/packages/lint) | [Apache 2.0](https://github.com/passsy/dart-lint/blob/master/LICENSE) |
| test | [pub.dev](https://pub.dev/packages/test) | [BSD](https://github.com/dart-lang/test/blob/master/pkgs/test/LICENSE) |


## [Coverage Converter](https://github.com/Flank/flank-dashboard/tree/master/metrics/coverage_converter)	

| Name | Source | License |
| :---: | :---: | :---: |
| args | [pub.dev](https://pub.dev/packages/args) | [BSD](https://github.com/dart-lang/args/blob/master/LICENSE) |
| meta | [pub.dev](https://pub.dev/packages/meta) |	[BSD](https://github.com/dart-lang/sdk/blob/master/pkg/meta/LICENSE) |
| equatable |	[pub.dev](https://pub.dev/packages/equatable) | [MIT](https://github.com/felangel/equatable/blob/master/LICENSE) |
| lcov | [pub.dev](https://pub.dev/packages/lcov) | [MIT](https://git.belin.io/cedx/lcov.dart/src/branch/main/LICENSE.md) |

### Dev dependencies
| Name | Source | License |
| :---: | :---: | :---: |
| coverage | [pub.dev](https://pub.dev/packages/coverage) | [Apache 2.0](https://github.com/dart-lang/coverage/blob/master/LICENSE) | 
| test_coverage | [pub.dev](https://pub.dev/packages/test_coverage) | [BSD](https://github.com/pulyaevskiy/test-coverage/blob/master/LICENSE) |
| lint | [pub.dev](https://pub.dev/packages/lint) | [Apache 2.0](https://github.com/passsy/dart-lint/blob/master/LICENSE) |
| mockito | [pub.dev](https://pub.dev/packages/mockito) | [Apache 2.0](https://github.com/dart-lang/mockito/blob/master/LICENSE) |
| test | [pub.dev](https://pub.dev/packages/test) | [BSD](https://github.com/dart-lang/test/blob/master/pkgs/test/LICENSE) |

## [Cli](https://github.com/Flank/flank-dashboard/tree/master/metrics/cli)

| Name | Source | License |
| :---: | :---: | :---: |
| args  | [pub.dev](https://pub.dev/packages/args) | [BSD](https://github.com/dart-lang/args/blob/master/LICENSE) |
| equatable | [pub.dev](https://pub.dev/packages/equatable) | [MIT](https://github.com/felangel/equatable/blob/master/LICENSE) |
| process_run | [pub.dev](https://pub.dev/packages/process_run) | [BSD](https://github.com/tekartik/process_run.dart/blob/master/LICENSE) |
| random_string | [pub.dev](https://pub.dev/packages/random_string) | [BSD](https://github.com/damondouglas/random_string.dart/blob/master/LICENSE) |
### Dev dependencies
| Name | Source | License |
| :---: | :---: | :---: |
| lint | [pub.dev](https://pub.dev/packages/lint) | [Apache 2.0](https://github.com/passsy/dart-lint/blob/master/LICENSE) |
| mockito | [pub.dev](https://pub.dev/packages/mockito) | [Apache 2.0](https://github.com/dart-lang/mockito/blob/master/LICENSE) |
| test | [pub.dev](https://pub.dev/packages/test) | [BSD](https://github.com/dart-lang/test/blob/master/pkgs/test/LICENSE) |

## [Firebase](https://github.com/Flank/flank-dashboard/tree/master/metrics/firebase)

| Name | Source | License |
| :---: | :---: | :---: |
| clock | [pub.dev](https://pub.dev/packages/clock) | [Apache 2.0](https://pub.dev/packages/clock/license) |
| collection | [pub.dev](https://pub.dev/packages/collection) | [BSD](https://pub.dev/packages/collection/license) |
| firebase_functions_interop | [pub.dev](https://pub.dev/packages/firebase_functions_interop) | [BSD](https://pub.dev/packages/firebase_functions_interop/license) |
| firebase_admin_interop | [pub.dev](https://pub.dev/packages/firebase_admin_interop) | [BSD](https://pub.dev/packages/firebase_admin_interop/license) |
| meta | [pub.dev](https://pub.dev/packages/meta) | [BSD](https://pub.dev/packages/meta/license) |



### Dev dependencies
| Name | Source | License |
| :---: | :---: | :---: |
| build_node_compilers | [pub.dev](https://pub.dev/packages/build_node_compilers) | [BSD](https://pub.dev/packages/build_node_compilers/license) |
| build_runner | [pub.dev](https://pub.dev/packages/build_runner) | [BSD](https://pub.dev/packages/build_runner/license) |
| lint | [pub.dev](https://pub.dev/packages/lint) | [Apache 2.0](https://pub.dev/packages/lint/license) |
| mockito | [pub.dev](https://pub.dev/packages/mockito) | [Apache 2.0](https://pub.dev/packages/mockito/license) |
| test | [pub.dev](https://pub.dev/packages/test) | [BSD](https://pub.dev/packages/test/license) |

## [Web](https://github.com/Flank/flank-dashboard/tree/master/metrics/web)

| Name | Source | License |
| :---: | :---: | :---: |	
| provider | [pub.dev](https://pub.dev/packages/provider) | [MIT](https://github.com/rrousselGit/provider/blob/master/LICENSE) |
| equatable | [pub.dev](https://pub.dev/packages/equatable) | [MIT](https://github.com/felangel/equatable/blob/master/LICENSE) |
| fcharts | [pub.dev](https://pub.dev/packages/fcharts) | [MIT](https://github.com/thekeenant/fcharts/blob/master/LICENSE) |
| url_launcher | [pub.dev](https://pub.dev/packages/url_launcher) | [BSD](https://github.com/flutter/plugins/blob/master/packages/url_launcher/url_launcher/LICENSE) |
| cupertino_icons | [pub.dev](https://pub.dev/packages/cupertino_icons) | [MIT](https://github.com/flutter/cupertino_icons/blob/master/LICENSE) |	
| cloud_firestore | [pub.dev](https://pub.dev/packages/cloud_firestore) | [BSD](https://github.com/FirebaseExtended/flutterfire/blob/master/packages/cloud_firestore/cloud_firestore/LICENSE) |
| cloud_functions | [pub.dev](https://pub.dev/packages/cloud_functions) | [BSD](https://github.com/FirebaseExtended/flutterfire/blob/master/packages/cloud_functions/cloud_functions/LICENSE) |	
| rxdart | [pub.dev](https://pub.dev/packages/rxdart) | [Apache 2.0](https://github.com/ReactiveX/rxdart/blob/master/LICENSE) |
| collection | [pub.dev](https://pub.dev/packages/collection) | [BSD](https://github.com/dart-lang/collection/blob/master/LICENSE) |	
| meta | [pub.dev](https://pub.dev/packages/meta) | [BSD](https://github.com/dart-lang/sdk/blob/master/pkg/meta/LICENSE) |
| firebase_auth | [pub.dev](https://pub.dev/packages/firebase_auth) | [BSD](https://github.com/FirebaseExtended/flutterfire/blob/master/packages/firebase_auth/firebase_auth/LICENSE) |
| firebase_analytics | [pub.dev](https://pub.dev/packages/firebase_analytics) | [BSD](https://github.com/FirebaseExtended/flutterfire/blob/master/packages/firebase_analytics/firebase_analytics/LICENSE) |
| universal_html | [pub.dev](https://pub.dev/packages/universal_html) | [Apache 2.0](https://github.com/dint-dev/web_browser/blob/master/LICENSE) |
| universal_io | [pub.dev](https://pub.dev/packages/universal_io) | [Apache 2.0](https://github.com/dint-dev/universal_io/blob/master/LICENSE) |
| google_sign_in | [pub.dev](https://pub.dev/packages/google_sign_in) | [BSD](https://github.com/flutter/plugins/blob/master/packages/google_sign_in/google_sign_in/LICENSE) |	
| selection_menu | [pub.dev](https://pub.dev/packages/selection_menu) | [MIT](https://github.com/HussainTaj-W/flutter-package-selection_menu/blob/master/LICENSE) |
| duration | [pub.dev](https://pub.dev/packages/duration) | [BSD](https://github.com/desktop-dart/duration/blob/master/LICENSE)|
| flutter_switch | [pub.dev](https://pub.dev/packages/flutter_switch) | [BSD](https://github.com/boringdeveloper/FlutterSwitch/blob/master/LICENSE) | 
| shimmer_animation | [pub.dev](https://pub.dev/packages/shimmer_animation) | [MIT](https://github.com/maddyb99/shimmer_animation/blob/master/LICENSE) |
| flutter_styled_toast | [pub.dev](https://pub.dev/packages/flutter_styled_toast) | [Apache 2.0](https://github.com/JackJonson/flutter_styled_toast/blob/master/LICENSE) | 
| statsfl | [pub.dev](https://pub.dev/packages/statsfl) | [MIT](https://github.com/gskinnerTeam/flutter-stats-fl/blob/master/LICENSE) | 
| flutter_svg | [pub.dev](https://pub.dev/packages/flutter_svg) | [MIT](https://github.com/dnfield/flutter_svg/blob/master/LICENSE) |
| hive | [pub.dev](https://pub.dev/packages/hive) | [Apache 2.0](https://github.com/hivedb/hive/blob/master/hive/LICENSE) |
| sentry | [pub.dev](https://pub.dev/packages/sentry) | [BSD](https://github.com/getsentry/sentry-dart/blob/main/LICENSE) |
| js | [pub.dev](https://pub.dev/packages/js) | [BSD](https://github.com/dart-lang/sdk/blob/master/pkg/js/LICENSE) |
| auto_size_text | [pub.dev](https://pub.dev/packages/auto_size_text) | [MIT](https://github.com/leisim/auto_size_text/blob/master/LICENSE) |
| rive | [pub.dev](https://pub.dev/packages/rive) | [MIT](https://pub.dev/packages/rive/license) |
| tuple | [pub.dev](https://pub.dev/packages/tuple) | [BSD](https://pub.dev/packages/tuple/license) |

### Dev dependencies
| Name | Source | License |
| :---: | :---: | :---: |	
| process_run | [pub.dev](https://pub.dev/packages/process_run) | [BSD](https://github.com/tekartik/process_run.dart/blob/master/LICENSE) |
| test | [pub.dev](https://pub.dev/packages/test) | [BSD](https://github.com/dart-lang/test/blob/master/pkgs/test/LICENSE) |	
| lint | [pub.dev](https://pub.dev/packages/lint) | [Apache 2.0](https://github.com/passsy/dart-lint/blob/master/LICENSE) |
| args | [pub.dev](https://pub.dev/packages/args) | [BSD](https://github.com/dart-lang/args/blob/master/LICENSE) |	
| mockito | [pub.dev](https://pub.dev/packages/mockito) | [Apache 2.0](https://github.com/dart-lang/mockito/blob/master/LICENSE) |
| network_image_mock | [pub.dev](https://pub.dev/packages/network_image_mock) | [BSD](https://github.com/stelynx/network_image_mock/blob/master/LICENSE) |
| uuid | [pub.dev](https://pub.dev/packages/uuid) | [MIT](https://github.com/Daegalus/dart-uuid/blob/master/LICENSE) |


## [API Mock Server](https://github.com/Flank/flank-dashboard/tree/master/api_mock_server)			

| Name | Source | License |
| :---: | :---: | :---: |
| http | [pub.dev](https://pub.dev/packages/http) | [BSD](https://github.com/dart-lang/http/blob/master/LICENSE) |

### Dev dependencies
| Name | Source | License |
| :---: | :---: | :---: |	
| lint | [pub.dev](https://pub.dev/packages/lint) | [Apache 2.0](https://github.com/passsy/dart-lint/blob/master/LICENSE) |
| test | [pub.dev](https://pub.dev/packages/test) | [BSD](https://github.com/dart-lang/test/blob/master/pkgs/test/LICENSE) |

## [Shell Words](https://github.com/Flank/flank-dashboard/tree/master/shell_words)		

| Name | Source | License |
| :---: | :---: | :---: |
| unicode |[pub.dev](https://pub.dev/packages/unicode) | [BSD](https://github.com/mezoni/unicode/blob/master/LICENSE) |

### Dev dependencies
| Name | Source | License |
| :---: | :---: | :---: |
| pedantic | [pub.dev](https://pub.dev/packages/pedantic) | [BSD](https://github.com/dart-lang/pedantic/blob/master/LICENSE) |
| test | [pub.dev](https://pub.dev/packages/test) | [BSD](https://github.com/dart-lang/test/blob/master/pkgs/test/LICENSE) |

## [Guardian](https://github.com/Flank/flank-dashboard/tree/master/guardian)		

| Name | Source | License |
| :---: | :---: | :---: |
| args | [pub.dev](https://pub.dev/packages/args) | [BSD](https://github.com/dart-lang/args/blob/master/LICENSE) |
| http | [pub.dev](https://pub.dev/packages/http) | [BSD](https://github.com/dart-lang/http/blob/master/LICENSE) |
| meta | [pub.dev](https://pub.dev/packages/meta) | [BSD](https://github.com/dart-lang/sdk/blob/master/pkg/meta/LICENSE) |
| xml | [pub.dev](https://pub.dev/packages/xml) | [MIT](https://github.com/renggli/dart-xml/blob/master/LICENSE) |
| equatable | [pub.dev](https://pub.dev/packages/equatable) | [MIT](https://github.com/felangel/equatable/blob/master/LICENSE) |

### Dev dependencies
| Name | Source | License |	
| :---: | :---: | :---: |
| lint | [pub.dev](https://pub.dev/packages/lint) | [Apache 2.0](https://github.com/passsy/dart-lint/blob/master/LICENSE) |
| test | [pub.dev](https://pub.dev/packages/test) | [BSD](https://github.com/dart-lang/test/blob/master/pkgs/test/LICENSE) |

## [Yaml Map](https://github.com/Flank/flank-dashboard/tree/master/yaml_map)	

| Name | Source | License |
| :---: | :---: | :---: |
| yaml | [pub.dev](https://pub.dev/packages/yaml) | [BSD](https://github.com/dart-lang/yaml/blob/master/LICENSE) |

### Dev dependencies
| Name | Source | License |	
| :---: | :---: | :---: |
| lint | [pub.dev](https://pub.dev/packages/lint) | [Apache 2.0](https://github.com/passsy/dart-lint/blob/master/LICENSE) |
| test | [pub.dev](https://pub.dev/packages/test) | [BSD](https://github.com/dart-lang/test/blob/master/pkgs/test/LICENSE) |

# Results
> What was the outcome of the project?

The document provides comprehensive information about the dependencies' licenses of different Metrics components.
