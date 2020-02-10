import 'package:equatable/equatable.dart';

/// A class representing secondary content that can be attached to messages.
class SlackAttachment extends Equatable {
  /// A valid URL that displays a small 16px by 16px image to the left of
  /// the [authorName] text.
  ///
  /// Will only work if [authorName] is present.
  final String authorIconUrl;

  /// A valid URL that will hyperlink the [authorName] text.
  ///
  /// Will only work if [authorName] is present.
  final String authorUrl;

  /// Small text used to display the author's name.
  final String authorName;

  /// A plain text summary of the attachment used in clients that don't show
  /// formatted text (eg. mobile notifications).
  final String fallback;

  /// An array of field objects that get displayed in a table-like way.
  final List<SlackAttachmentField> fields;

  /// Some brief text to help contextualize and identify an attachment.
  final String footer;

  /// A valid URL to an image file that will be displayed beside the footer text.
  ///
  /// Will only work if [authorName] is present.
  final String footerIconUrl;

  /// A valid URL to an image file that will be displayed at the bottom of the
  /// attachment. Slack supports GIF, JPEG, PNG, and BMP formats.
  ///
  /// Cannot be used with [thumbUrl].
  final String imageUrl;

  /// Text that appears above the message attachment block. It can be formatted
  /// as plain text, or with markdown.
  final String pretext;

  /// The main body text of the attachment. It can be formatted as plain text,
  /// or with markdown.
  final String text;

  /// A valid URL to an image file that will be displayed as a thumbnail on the
  /// right side of a message attachment. Slack currently supports the following
  /// formats: GIF, JPEG, PNG, and BMP.
  final String thumbUrl;

  /// Large title text near the top of the attachment.
  final String title;

  /// A valid URL that turns the [title] text into a hyperlink.
  final String titleUrl;

  /// Changes the color of the border on the left side of this attachment from
  /// the default gray.
  final SlackAttachmentColor color;

  /// A Unix timestamp that is used to related your attachment to a specific
  /// time.
  ///
  /// The attachment will display the additional timestamp value as part
  /// of the attachment's [footer].
  final DateTime timestamp;

  const SlackAttachment({
    this.authorIconUrl,
    this.authorUrl,
    this.authorName,
    this.fallback,
    this.fields,
    this.footer,
    this.footerIconUrl,
    this.imageUrl,
    this.pretext,
    this.text,
    this.thumbUrl,
    this.title,
    this.titleUrl,
    this.color,
    this.timestamp,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (authorIconUrl != null) map['author_icon'] = authorIconUrl;
    if (authorUrl != null) map['author_link'] = authorUrl;
    if (authorName != null) map['author_name'] = authorName;
    if (fallback != null) map['fallback'] = fallback;
    if (fields != null && fields.isNotEmpty) {
      map['fields'] = fields.map((f) => f.toJson()).toList();
    }
    if (footer != null) map['footer'] = footer;
    if (footerIconUrl != null) map['footer_icon'] = footerIconUrl;
    if (imageUrl != null) map['image_url'] = imageUrl;
    if (pretext != null) map['pretext'] = pretext;
    if (text != null) map['text'] = text;
    if (thumbUrl != null) map['thumb_url'] = thumbUrl;
    if (title != null) map['title'] = title;
    if (titleUrl != null) map['title_link'] = titleUrl;
    if (color != null && color.value != null) map['color'] = color.value;
    if (timestamp != null) map['ts'] = timestamp.millisecondsSinceEpoch;

    return map;
  }

  @override
  List<Object> get props => [
        authorIconUrl,
        authorUrl,
        authorName,
        fallback,
        fields,
        footer,
        footerIconUrl,
        imageUrl,
        pretext,
        text,
        thumbUrl,
        title,
        titleUrl,
        color,
        timestamp,
      ];

  @override
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}

/// A class that represents [SlackAttachment] color.
class SlackAttachmentColor extends Equatable {
  /// Color value.
  ///
  /// Can either be one of 'good' (green), 'warning' (yellow), 'danger' (red),
  /// or any hex color code (eg. #439FE0).
  final String value;

  const SlackAttachmentColor(this.value);

  const SlackAttachmentColor.good() : value = 'good';

  const SlackAttachmentColor.warning() : value = 'warning';

  const SlackAttachmentColor.danger() : value = 'danger';

  @override
  List<Object> get props => [value];

  @override
  String toString() {
    return value;
  }
}

/// A class that represents a field from [SlackAttachment.fields] property.
class SlackAttachmentField extends Equatable {
  /// Shown as a bold heading displayed in the field object.
  /// It cannot contain markup.
  final String title;

  ///	The text value displayed in the field object. It can be formatted as
  /// plain text or with markdown.
  final String value;

  /// Indicates whether the field object is short enough to be displayed
  /// side-by-side with other field objects.
  ///
  /// Defaults to `false`
  final bool short;

  const SlackAttachmentField({
    this.title,
    this.value,
    this.short = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'value': value,
      'short': short,
    };
  }

  @override
  List<Object> get props => [title, value, short];

  @override
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}
