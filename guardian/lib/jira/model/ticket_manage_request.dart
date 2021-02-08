// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

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
