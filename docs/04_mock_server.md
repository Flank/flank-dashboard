# Mock server
> Summary of the proposed change

Implementation tips for the **mock server** approach for E2E API testing.

# References
> Link to supporting documentation, GitHub tickets, etc.

- Dart [HttpServer](https://api.dart.dev/stable/2.7.1/dart-io/HttpServer-class.html)
- Dart MockWebServer [API reference](https://pub.dev/documentation/mock_web_server/latest/index.html)

# Motivation
> What problem is this project solving?

Implement E2E 3rd-party API testing.

# Goals
> Identify success metrics and measurable goals.

* Simple to integrate
* Simple to write tests

# Non-Goals
> Identify what's not in scope.

Integration tips are not in scope because they depend on implementations of clients under tests.

# Design
> Explain and diagram the technical design

`Slack API adapter` → `Slack API client` → `HTTP request` → `Mock web server` → `Request handler` → `HTTP response`

> Identify risks and edge cases

HTTP requests must be made directly to the mock server. The client HTTP requests must be **redirected** to the mock server, otherwise the requests will be sent to the real server.

# API
> What will the proposed API look like?

Create a mock server that listens for HTTP requests and responds with mock data. 

```dart
class SlackMockServer extends ApiMockServer {
  @override
  List<RequestHandler> get handlers => [
    RequestHandler.post(
      path: '/services/00001/00001/00001',
      dispatcher: _handlePost,
    ),
  ];

  void _handlePost(HttpRequest request) {
    // implementation
    request.response
      ..statusCode = HttpStatus.ok
      ..write(mockResponse)
      ..close();
  }
}
```

Redirect requests to the mock server within the group of tests (implementation may vary depending on the client).

```dart
void main() {
  group('SlackClient', () {
    final slackClient = SlackClient();
    final slackMockServer = SlackMockServer();
    String serverUrl;
    
    setUpAll(() async {
      await slackMockServer.init();
      serverUrl = slackMockServer.url;
    });
    
    tearDownAll(() async {
      await slackMockServer.close();
    });
    
    test('test1', () {
      final message = SlackMessage(text: 'test');
      final response = slackClient.sendMessage('$serverUrl/services/00001/00001/00001', message);
      final expected = SlackResult.success();

      expect(response, completion(equals(expected)));
    });
  });
}
```

# Dependencies
> What is the project blocked on?

No blockers.

> What will be impacted by the project?

All E2E API testing strategy implementations are impacted.

# Alternatives Considered
> Summarize alternative designs (pros & cons)

- [MockWebServer package](https://pub.dev/documentation/mock_web_server/latest/index.html): 
    - Pros 
        - Server interactions out-of-the-box. MockWebServer encapsulates server binding.
        - Provides a lot of ways to mock the response. This is possible to set a [handler method](https://pub.dev/documentation/mock_web_server/latest/mock_web_server/MockWebServer/dispatcher.html) for requests, to [enqueue response](https://pub.dev/documentation/mock_web_server/latest/mock_web_server/MockWebServer/enqueue.html) and, finally, to set a [default response](https://pub.dev/documentation/mock_web_server/latest/mock_web_server/MockWebServer/defaultResponse.html).
    - Cons
        - It is very easy to accidentally introduce hidden dependencies between tests that should be isolated (see example below).
            ```dart
            void main() {
              group('SlackClient', () {
                final slackClient = SlackClient();
                final mockWebServer = MockWebServer();
                String serverUrl;
              
                setUpAll(() async {
                  await mockWebServer.start();
                  serverUrl = mockWebServer.url;
                });
              
                tearDownAll(() async {
                  await mockWebServer.shutdown();
                });
              
                test('test1', () {
                  mockWebServer.dispatcher = (request) async {
                    return MockResponse()..httpCode = HttpStatus.ok;
                  };
              
                  final message = SlackMessage(text: 'test');
                  final response = slackClient.sendMessage('$serverUrl/services/00001/00001/00001', message);
                  final expected = SlackResult.success();
              
                  expect(response, completion(equals(expected)));
                });
              
                test('test2', () {
                  mockWebServer.enqueueResponse(MockResponse()..httpCode = HttpStatus.badRequest);
              
                  final message = SlackMessage();
                  final response = slackClient.sendMessage('$serverUrl/services/00001/00001/00001', message);
                  final expected = SlackResult.error();
              
                  // fails since `MockWebServer.dispatcher` has greater priority in implementation than enqueued responses
                  expect(response, completion(equals(expected)));
                });
              });
            }
            ```
        - MockWebServer is badly typed. Almost all methods of MockWebServer return `dynamic` as denoted by Dart Analyzer though the actual runtime type is different (see example below). Therefore, using MockWebServer without knowing how its methods are implemented is error prone.
            ```dart
            void main() {
              // start() type is `dynamic Function()`
              final start = mockWebServer.start();
              // runtime type of the result is `Future<dynamic>`
              print(start.runtimeType);
              // actual type from the implementation is `Future<void> Function()` 
              
              // enqueue() type is `dynamic Function({...})`
              final enqueueResponse = mockWebServer.enqueue(httpCode: 200);
              // runtime type of the result is `Null`
              print(enqueueResponse.runtimeType);
              // actual type from the implementation is `void Function({...})`
            }
            ```
# Timeline
> Document milestones and deadlines.
 
DONE:
 - Added implementing E2E API testing document.
 
NEXT:
 - Integrate E2E API testing into the project.
   
# Results
> What was the outcome of the project?

Work in progress.
