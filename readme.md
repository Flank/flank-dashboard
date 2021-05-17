# Projects
This repository holds the source code of the following projects:
- [API Mock Server](#test_tube-api-mock-server)
- [Guardian](#shield-guardian)
- [Metrics](#bar_chart-metrics)
- [Shell Words](#shell-shell-words)
- [YAML Map](#world_map-yaml-map)

Let's review each of them in a bit more details:

## :test_tube: Api Mock Server
[Api Mock Server](api_mock_server) is a package that provides an abstraction to create mock HTTP servers for testing 3-rd party API integrations.

### Features
- Authentication verification (by providing `AuthCredentials`);
- Handling `GET`, `DELETE`, `POST`, `PUT` HTTP methods;
- Flexible request URL matching (using `ExactPathMatcher` or `RegExpPathMatcher`).

<details>
  <summary>Usage example</summary>

Consider this short example on how to use the API Mock Server.

First, let's consider we have the following API client, and we need to test its `fetchBar` method:
```dart
import 'package:http/http.dart' as http;

class TestClient {
  final String apiUrl;

  const TestClient(this.apiUrl);

  Future<String> fetchBar() async {
    final response = await http.get('$apiUrl/foo');

    if (response.statusCode != 200) return null;

    return response.body;
  }
}
```

After that, let's implement an Api Mock server to test the `TestClient`.
```dart
class MockServer extends ApiMockServer {
  @override
  List<RequestHandler> get handlers => [
        RequestHandler.get(
          pathMatcher: ExactPathMatcher('/foo'),
          dispatcher: _fooHandler,
        ),
      ];

  Future<void> _fooHandler(HttpRequest request) async {
    request.response.write('bar');
    
    await request.response.flush();
    await request.response.close();
  }
}
```

Now, let's use the created `MockServer` in tests:
```dart
void main() {
  group("TestClient", () {
    final mockServer = MockServer();
    TestClient client;

    setUpAll(() async {
      await mockServer.start();
      client = TestClient(mockServer.url);
    });

    tearDownAll(() async {
      await mockServer.close();
    });
    
    test(
      ".fetchBar() returns 'bar'",
      () async {
        const expectedResponse = 'bar';

        final actualResponse = await client.fetchBar();

        expect(actualResponse, equals(expectedResponse));
      },
    );
  });
}
```
</details>

## :shield: Guardian
[Guardian](guardian) is a tool designed for detecting and notifying about flaky tests by analyzing JUnit XML files. This tool accepts the unit test reports and compares the actual and previous test results stored in a database. If the test is considered flaky, Guardian notifies the team using Slack and creates an issue in Jira.

### Features:
- Slack integration for notifications;

## :bar_chart: Metrics
[Metrics](metrics/readme.md) is a set of software components to collect and review software project metrics like performance, build stability, and codebase quality.
The Metrics project includes the following components:
- [Metrics Web](metrics/web) - a web application for the project metrics visualisation.
- [CI Integrations](metrics/ci_integrations) - a CLI application that integrates with popular CI tools, such as Jenkins, GitHub Actions, and Buildkite, to collect software project metrics.
- [Metrics CLI](metrics/cli) - a command-line tool that simplifies the deployment of Metrics components (Flutter Web application, Cloud Functions, Firestore Rules, and general setup).
- [Firebase](metrics/firebase) - defines the Firestore Security Rules and Cloud Functions needed to provide a secure and efficient serverless backend.
- [Coverage Converter](metrics/coverage_converter) - a tool that converts coverage data of specific coverage formats into [Metrics coverage format](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/01_ci_integration_module_architecture.md#coverage-report-format).

![Metrics Dashboard](docs/images/dashboard_ui.png)

## :shell: Shell Words
[Shell Words](shell_words) is a package that provides tools for parsing the command-line strings.

### Features
- Parsing shell commands into words for both Windows and POSIX depending on the underlying OS (using `split` function).

<details>
  <summary>Usage example</summary>

Consider this short example on how to use the shell words parser.

```dart
import 'package:shell_words/shell_words.dart';

void main() {
  final shellWords = split('cd foo/bar --some-flag=flag');

  print(shellWords.words); // [cd, foo/bar, --some-flag=flag]
  print(shellWords.error); // any occurred error
}
```

</details>

## :world_map: YAML Map
[YAML Map](yaml_map) is a wrapper around Dart's [`yaml`](https://pub.dev/packages/yaml) package that simplifies working with YAML documents.

### Features
- Comparing to the [`yaml`](https://pub.dev/packages/yaml) package, parses the result to core Dart types.
- Converting Dart Maps to YAML formatted strings.

<details>
  <summary>Usage example</summary>

Consider this short example on how to use the main `YamlMapParser` and `YamlMapFormatter` classes:

```dart
import 'package:yaml_map/src/yaml_map_formatter.dart';
import 'package:yaml_map/src/yaml_map_parser.dart';

void main() {
  const yaml = '''
  foo:
    bar:
      baz: 1
  ''';

  const yamlMapParser = YamlMapParser();
  final parsedYaml = yamlMapParser.parse(yaml);

  print(parsedYaml); // {foo: {bar: {baz: 1}}}
  print(parsedYaml['foo']); // {bar: {baz: 1}}
  print(parsedYaml['foo']['bar']); // {baz: 1}
  print(parsedYaml['foo']['bar']['baz']); // 1

  final yamlFormatter = YamlMapFormatter();
  print(yamlFormatter.format(parsedYaml));
  // foo: 
  //   bar: 
  //     baz: 1
}
```

</details>

# Getting Started
Consider these useful links that may help you to get started:
1. [GitHub Agile process :chart_with_upwards_trend:](docs/02_process.md)
2. [Dart code style :nail_care:](docs/09_dart_code_style.md)
3. [Collaboration :raised_hands:](docs/10_collaboration.md)
4. [Effective Dart :dart:](https://dart.dev/guides/language/effective-dart)

# :scroll: License
Licensed under the terms of the Apache 2.0 License that can be found in the [LICENSE file](https://github.com/platform-platform/monorepo/blob/master/LICENSE).

Consider the following [document](docs/15_dependencies_licenses.md) that describes the licenses for all 3-rd party libraries used in projects of this repository.
