import 'package:ci_integration/common/config/parser/destination_config_parser.dart';
import 'package:ci_integration/firestore/config/model/firestore_config.dart';

/// A configuration parser for the Firestore destination integration.
class FirestoreConfigParser
    implements DestinationConfigParser<FirestoreConfig> {
  const FirestoreConfigParser();

  @override
  bool canParse(Map<String, dynamic> map) {
    return map!=null && map['firestore'] != null;
  }

  @override
  FirestoreConfig parse(Map<String, dynamic> map) {
    if (map == null) return null;

    final firestoreConfigMap = map['firestore'] as Map<String, dynamic>;
    return FirestoreConfig.fromJson(firestoreConfigMap);
  }
}
