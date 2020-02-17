import 'package:guardian/slack/model/slack_text_object.dart';

extension ValidateSectionBlockExtension on SlackTextObject {
  bool get valid => text != null && text.isNotEmpty;
}
