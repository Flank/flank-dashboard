import 'package:args/args.dart';
import 'package:links_checker/common/arguments/models/links_checker_arguments.dart';
import 'package:links_checker/common/arguments/parser/links_checker_arguments_parser.dart';
import 'package:links_checker/common/checker/links_checker.dart';
import 'package:links_checker/common/command/links_checker_command.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group("LinksCheckerCommand", () {
    final linksChecker = _LinksCheckerMock();

    test(
      "checks the given files by paths",
      () {
        when(linksChecker.checkFiles(any)).thenReturn(null);

        final command = _LinksCheckerCommandFake(linksChecker: linksChecker);

        command.run();

        verify(linksChecker.checkFiles(any)).called(equals(1));
      },
    );
  });
}

/// A [LinksCheckerCommand] fake class used to test the non-abstract methods.
class _LinksCheckerCommandFake extends LinksCheckerCommand {
  @override
  String get description => '';

  @override
  String get name => '';

  @override
  final LinksChecker linksChecker;

  /// Creates a new instance of this fake.
  ///
  /// If the [argumentsParser] is null, the stub implementation used.
  _LinksCheckerCommandFake({
    LinksCheckerArgumentsParser argumentsParser,
    LinksChecker linksChecker,
  })  : linksChecker = linksChecker ?? _LinksCheckerMock(),
        super(argumentsParser: argumentsParser ?? _ArgumentsParserStub());
}

/// A stub implementation of the [LinksCheckerArgumentsParser].
class _ArgumentsParserStub extends LinksCheckerArgumentsParser {
  /// A [LinksCheckerArguments] used in tests.
  final _arguments = LinksCheckerArguments(paths: 'file1 file2');

  @override
  LinksCheckerArguments parseArgResults(ArgResults argResults) {
    return _arguments;
  }
}

class _LinksCheckerMock extends Mock implements LinksChecker {}
