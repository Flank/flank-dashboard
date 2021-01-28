import 'package:cli/util/prompt_wrapper.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  test('test', () {
    final mock = PromptMock();

    when(mock.prompt('text')).thenAnswer((_)  {
      print('yahioo');
      return Future.value('x');
    });

    A.init(mock);

    final b = B();

    b.run();
  });
}

class PromptMock extends Mock implements PromptWrapper {}
