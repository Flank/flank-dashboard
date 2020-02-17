import 'package:guardian/slack/model/slack_section_block.dart';

import 'validate_text_object_extension.dart';

extension ValidateSectionBlockExtension on SlackSectionBlock {
  bool get valid {
    final textValid = text != null && text.valid;
    final fieldsValid = fields != null &&
        fields.isNotEmpty &&
        fields.every((text) => text.valid);

    if (text == null) {
      return fieldsValid;
    } else if (fields == null) {
      return textValid;
    } else {
      return textValid && fieldsValid;
    }
  }
}
