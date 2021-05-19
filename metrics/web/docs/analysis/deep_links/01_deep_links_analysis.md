# Deep Links Approaches Analysis
> Feature description / User story.

As a User, I want to pass direct links to project and/or project groups, so that other users can navigate easier.

# Analysis
> Describe the general analysis approach.

During the analysis stage, we are going to investigate the implementation approaches for deep linking in the Metrics Web application and choose the most suitable one for us.

## Feasibility study
> A preliminary study of the feasibility of implementing this feature.

Since the Flutter [supports deep links](https://flutter.dev/docs/development/ui/navigation/deep-linking) we can implement the deep linking in the Metrics Web application.

## Requirements
> Define requirements and make sure that they are complete.

- Possibility to handle deep links;
- Possibility to generate deep links in response to UI events (filtering, dropdown selections, searching, etc.);
- Extensible and testable implementation approach.

## Landscape
> Look for existing solutions in the area.

We need to decide with the approaches for the following concepts:
- [Deep Linking Approach](#deep-linking-approach) - meaning how to save the application state in the URLs.
- [Deep Links Integration Approach](#deep-links-integration-approach) - meaning how to integrate deep links to the Metrics Web Application.

Let's review them in the next sections.

### Deep Linking approach
There are two main approaches for deep linking: `query parameters` and `path segments`.   
Let's consider a problem that we are to solve using deep links. For example, we need to save a project name filter's state in a deep link. Let's compare the listed approaches for solving this problem:

### Query Parameters
Using query parameters, the deep link may look like the following:
`https://metrics.web.app/dashboard?project_name=web_app`   

#### Description
Usually, query parameters are used to represent some filtering and grouping criteria. Such an approach allows combining several searching, filtering, and grouping parameters simultaneously.

#### Pros
- Dart provides a perfect API for parsing query parameters. Consider the following code snippet that demonstrates how to parse query parameters in Dart:
```dart
  final url = Uri.parse("https://domain.com?foo=bar&bar=baz&array=q&array=w");
  
  print(url.query); // foo=bar&bar=baz&array=q&array=w
  print(url.queryParameters); // {foo: bar, bar: baz, array: w}
  print(url.queryParametersAll); // {foo: [bar], bar: [baz], array: [q, w]}
```

- Query parameters are flexible - meaning that we can combine multiple searching, filtering, or grouping criteria.

#### Cons
- Query parameters may be less readable comparing to the path segments approach.

### Path segments    
Using path segments, the deep link may look like the following:
`https://metrics.web.app/dashboard/project_name/web_app`  

#### Description
Path segments are usually used to identify a specific resource. They may be more readable to users, however, they are less flexible in terms of combining multiple searching, filtering, or grouping parameters.
 
#### Pros
- Path segments may be more readable to users.

#### Cons
- As Dart provides a List-based API for working with path segments, parsing of the deep links depends on the order of path segments, which makes parsing deep links based on path segments much harder. The following code snippet demonstrates the path segments parsing in Dart:
```dart
  final url = Uri.parse("https://domain.com/foo/bar/baz");

  print(url.path); // /foo/bar/baz
  print(url.pathSegments); // [foo, bar, baz]
```
- Less flexible approach - meaning that it is hard to combine multiple searching, filtering, or grouping arguments.

### Conclusion
According to the [requirements](#requirements) listed above, and the comparison of the [`query parameters`](#query-parameters) and the [`path segments`](#path-segments), we choose to use the [`query parameters`](#query-parameters) approach for deep linking.

### Deep Links Integration Approach
(Using notifier vs straight using route parameters)

### Prototyping
> Create a simple prototype to confirm that implementing this feature is possible.

### System modeling
> Create an abstract model of the system/feature.
