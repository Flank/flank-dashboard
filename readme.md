# Projects
This repository holds the source code of the following projects:
- [Metrics](#bar_chart-metrics)
- [API Mock Server](#test_tube-api-mock-server)
- [Guardian](#shield-guardian)
- [Shell Words](#shell-shell-words)
- [YAML Map](#world_map-yaml-map)

Let's review each of them in a bit more details:

## :bar_chart: Metrics
[Metrics](metrics/readme.md) is a set of software components to collect and review software project metrics like performance, build stability, and codebase quality. 
The Metrics project integrates with the following CI tools to collect software project metrics:
- [Buildkite](https://buildkite.com/docs/tutorials/getting-started)
- [Github Actions](https://docs.github.com/en/actions/quickstart)
- [Jenkins](https://jenkins.io/doc/)

The Metrics Web Application displays the next project metrics on the dashboard:
| Metric | Description |
| --- | --- |
| `Build Status`   | The result of the latest build. |
| `Build Results`   | Includes the build results and duration of the latest builds. |
| `Performance`   | An average build duration of successful builds by the last 7 days, excluding the queue time. |
| `Builds`   | A count of performed builds of the project per week. |
| `Stability`   | A ratio of successful builds to finished builds for the last 30 builds. |
| `Coverage`   | A last successful build's code coverage percent. |

See [Project metrics definitions](https://github.com/platform-platform/dashboard/blob/improve_repository_readme/docs/05_project_metrics.md) document to get more information about project metrics.

![Metrics Dashboard](docs/images/dashboard_ui.png)

## :test_tube: Api Mock Server
[Api Mock Server](api_mock_server) is a package that provides an abstraction to create mock HTTP servers for testing 3-rd party API integrations. Consider the [Third Party API Testing](https://github.com/platform-platform/monorepo/blob/master/docs/03_third_party_api_testing.md) and [Mock Server](https://github.com/platform-platform/monorepo/blob/master/docs/04_mock_server.md) documents for more details.

### Features
The API Mock server allows mocking the following real-server functionality:

- Verify requests' authentication (by providing `AuthCredentials`);
- Handle requests with `GET`, `DELETE`, `POST`, `PUT` HTTP methods;
- Handle routing by matching requests' URL (using `ExactPathMatcher` or `RegExpPathMatcher`).

<details>
  <summary>Usage example</summary>

Consider this short example on how to use the API Mock Server.

Let's assume that we have the following API client with the `fetchBar` method we should cover with tests:
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

Then, we should implement the mock server to test the desired client. The following `MockServer` implements the API Mock Server and mocks the behavior of the real server:
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

Finally, `start` the implemented mock server and provide the base path to the client under tests (`TestClient` in our case). To prevent memory leaks, close the server after all tests are finished. We should test the `fetchBar` method as follows:
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
[Guardian](guardian) is a tool designed for detecting flaky tests by analyzing JUnit XML reports and notifying the team about the results. This tool accepts the actual reports and compares them to the stored results in a database. If the test is considered flaky, Guardian notifies the team using Slack and/or Jira integrations.

### Features:
- Slack integration for notifications.


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
- Parsing the YAML documents to core Dart types.
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

# Contibuting to this repository
Consider these useful links that may help you to get started:
1. [GitHub Agile process :chart_with_upwards_trend:](docs/02_process.md)
2. [Dart code style :nail_care:](docs/09_dart_code_style.md)
3. [Collaboration :raised_hands:](docs/10_collaboration.md)
4. [Effective Dart :dart:](https://dart.dev/guides/language/effective-dart)

# :scroll: License
Licensed under the terms of the Apache 2.0 License that can be found in the [LICENSE file](https://github.com/platform-platform/monorepo/blob/master/LICENSE).

Consider the [Dependencies Licenses](docs/15_dependencies_licenses.md) document that describes the licenses for all 3-rd party libraries used in projects of this repository.
