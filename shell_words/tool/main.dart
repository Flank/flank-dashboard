import 'package:shell_words/shell_words.dart';

void main(List<String> arguments) {
  var input =
      r'''echo ^^^^^&' ''';
  print('Input: ' + input);
  var result = split(input);
  print('Result: ');
  if (result.error == null) {
    for (var string in result.words) {
      print(string);
    }
  } else {
    print(result.error);
  }
}
