import 'package:args/args.dart';

class SlackMessage {
  final String url;
  final String body;

  SlackMessage({
    this.url,
    this.body,
  });

  factory SlackMessage.fromArgs(ArgResults results) {
    if (results == null) return null;

    return SlackMessage(
      url: results['url'],
      body: results['body'],
    );
  }
}
