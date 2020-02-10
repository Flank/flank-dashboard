class SlackAttachment {
  final String authorIconUrl;
  final String authorUrl;
  final String authorName;
  final String fallback;
  final List<SlackAttachmentField> fields;
  final String footer;
  final String footerIconUrl;
  final String imageUrl;
  final String pretext;
  final String text;
  final String thumbUrl;
  final String title;
  final String titleUrl;
  final SlackAttachmentColor color;
  final DateTime timestamp;

  SlackAttachment({
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
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}

class SlackAttachmentColor {
  final String value;

  SlackAttachmentColor(this.value);

  SlackAttachmentColor.good() : value = 'good';

  SlackAttachmentColor.warning() : value = 'warning';

  SlackAttachmentColor.danger() : value = 'danger';

  @override
  String toString() {
    return value;
  }
}

class SlackAttachmentField {
  final String title;
  final String value;
  final bool short;

  SlackAttachmentField({
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
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}
