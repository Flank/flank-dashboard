// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

library junit_xml;

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:xml/xml.dart' as xml;

part 'model/junit_property.dart';

part 'model/junit_system_data.dart';

part 'model/junit_system_err_data.dart';

part 'model/junit_system_out_data.dart';

part 'model/junit_test_case.dart';

part 'model/junit_test_case_error.dart';

part 'model/junit_test_case_execution_result.dart';

part 'model/junit_test_case_failure.dart';

part 'model/junit_test_case_skipped.dart';

part 'model/junit_test_suite.dart';

part 'model/junit_test_suites.dart';

part 'model/junit_xml_report.dart';

part 'parser/element_parser/properties_parser.dart';

part 'parser/element_parser/system_err_parser.dart';

part 'parser/element_parser/system_out_parser.dart';

part 'parser/element_parser/test_case_error_parser.dart';

part 'parser/element_parser/test_case_failure_parser.dart';

part 'parser/element_parser/test_case_parser.dart';

part 'parser/element_parser/test_case_skipped_parser.dart';

part 'parser/element_parser/test_suite_parser.dart';

part 'parser/element_parser/test_suites_parser.dart';

part 'parser/element_parser/xml_attribute_value_parser.dart';

part 'parser/element_parser/xml_element_parser.dart';

part 'parser/junit_xml_parser.dart';
