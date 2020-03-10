# Testing Third Party API
> Summary of the proposed change

Research 3rd party API testing strategies.

# References
> Link to supporting documentation, GitHub tickets, etc.

- [Testing Third Party Interactions](https://thoughtbot.com/blog/testing-third-party-interactions)

# Motivation
> What problem is this project solving?

Rapidly detect regressions in API clients.

# Goals
> Identify success metrics and measurable goals.

* Test suite performance
* Test suite stability

# Non-Goals
> Identify what's not in scope.

End to end testing with real network requests is not in scope because E2E tests are slow and flaky.

## Definitions

Here are four ways to test a 3rd party API.

|  | **Adapter** | **HTTP** |
| --- | --- | --- |
| **Stubbed** | Stub methods on adapter | Stub HTTP requests |
| **Real** | Real request to fake adapter | Real HTTP request to fake service |

**Adapter** is a class that provides high level methods on top of a lower level HTTP client. 
Each adapter makes requests to the third party API through a **HTTP** client. 

## [Stubbing the adapter](https://thoughtbot.com/blog/testing-third-party-interactions#stubbing-the-adapter)
Unit-test objects that depend on data from other services.

- Dart mock package inspired by Mockito: [mockito](https://pub.dev/packages/mockito)

## [Stubbing the network](https://thoughtbot.com/blog/testing-third-party-interactions#stubbing-the-network)
Execute the service without making a real network request.

- Dart Nock HTTP requests mocking package: [nock](https://pub.dev/packages/nock)

## [Swapping out the adapter](https://thoughtbot.com/blog/testing-third-party-interactions#swapping-out-the-adapter)
Assert on data that has been sent or received from the service.

- Dart HTTP package: [http](https://pub.dev/packages/http) (has [mock client](https://pub.dev/documentation/http/latest/testing/MockClient-class.html))
- Dart Nock HTTP requests mocking package: [nock](https://pub.dev/packages/nock)

## [Swapping out the server](https://thoughtbot.com/blog/testing-third-party-interactions#swapping-out-the-server)
Instead of trying to prevent HTTP, you make **real HTTP requests** to a **local mock server**. 
Allows full end-to-end testing of an app.

- Dart HTTP server: [http_server](https://pub.dev/packages/http_server)
- Dart MockWebServer package: [mock_web_server](https://pub.dev/packages/mock_web_server)

# Design
> Identify risks and edge cases

Server API changes will break the client. The above approaches test the client in isolation. The client tests will continue to pass even if the server breaks the API contract.

# API
> What will the proposed API look like?

See the document in [Implementing Swapping out the server approach](04_mock_server.md)

# Dependencies
> What is the project blocked on?

No blockers.

> What will be impacted by the project?

All 3rd party API integrations are impacted by the API testing strategy.

# Alternatives Considered
> Summarize alternative designs (pros & cons)

- Making real HTTP requests to real service. End to end tests will detect when server API changes have broken clients, however they are slow and flaky.

# Timeline
> Document milestones and deadlines.

DONE:
  - Investigate third-party API testing approaches.
  - Added implementing e2e API testing document.

# Results
> What was the outcome of the project?

Work in progress.
