import 'package:args/args.dart';

class OpenTicketRequest {
  final String projectId;

  OpenTicketRequest({
    this.projectId,
  });

  factory OpenTicketRequest.fromArgs(ArgResults argResults) {
    return OpenTicketRequest(
      projectId: argResults['projectId'] as String,
    );
  }
}

class UpdateTicketRequest {}

class CloseTicketRequest {}
