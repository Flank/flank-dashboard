// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/destination/firestore/config/model/firestore_destination_config.dart';
import 'package:ci_integration/integration/interface/destination/config/parser/destination_config_parser.dart';

/// A configuration parser for the Firestore destination integration.
class FirestoreDestinationConfigParser
    implements DestinationConfigParser<FirestoreDestinationConfig> {
  /// Creates a new instance of the [FirestoreDestinationConfigParser].
  const FirestoreDestinationConfigParser();

  @override
  bool canParse(Map<String, dynamic> map) {
    return map != null && map['firestore'] != null;
  }

  @override
  FirestoreDestinationConfig parse(Map<String, dynamic> map) {
    if (map == null) return null;

    final firestoreConfigMap = map['firestore'] as Map<String, dynamic>;
    return FirestoreDestinationConfig.fromJson(firestoreConfigMap);
  }
}
