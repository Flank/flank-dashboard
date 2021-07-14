import 'package:mockito/mockito.dart';

extension ErrorAnswer on PostExpectation {
  void thenAnswerError(Object error) {
    thenAnswer((_) => Future.error(error));
  }
}
