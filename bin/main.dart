import 'package:guardian/runner/guardian_runner.dart';

void main(List<String> arguments) {
  final runner = GuardianRunner();

  try {
    runner.run(arguments);
  } catch (error) {
    print(error);
  }
}
