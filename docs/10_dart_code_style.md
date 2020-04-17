# Dart code style
> Summary of the proposed change

Make sure our code style is consistent in parts that are not covered in the Dart code style.

# References
> Link to supporting documentation, GitHub tickets, etc.

- [Effective Dart](https://dart.dev/guides/language/effective-dart/) is the main source for 
all code style, documentation, design and usage conventions.


# Motivation
> What problem is this project solving?

As Dart has a great code style available
that we use on this project we noticed that in some real-world cases there is no guidance,
so here we collect all cases that we think important to clarify to make sure that the code style
is consistent through the project.

# Goals

> Identify success metrics and measurable goals.

Have a document that can be used in code reviews to clarify code style issues and make sure
that code style is consistent.

# Non-Goals

> Identify what's not in scope.

- Other languages we might use (Bash scripts, JavaScript).

# Documentation

## Unit tests
1. Test Group description starts with Capital letter:
    ```dart
    group("DashboardPage", () {
    ```
2. Test description inside a group starts with a small letter:
    ```dart
    test("should throw ArgumentError trying to create an instance with null CI client", 
    ```
3. Test description not inside Test Group starts with Capital letter:
    ```dart
    testWidgets("Can't create widget without data",
   ```
4. Group and test descriptions should not end with a dot (.).
5. If method name (or named constructor) is used in test description it should start with dot (.)
and should have parenthesis:

    ```dart
    test(".fromJson() should create an instance from the json map", () {
    ```
6. Use group with class under test name:
    ```dart
    group("ReceiveProjectMetricUpdates", () {
       .....
       test("loads all fields in the performance metrics", () {
    ```
7. Multiline test description shouldn't be used as single test can't 
be started in [Intellij](https://youtrack.jetbrains.com/issue/WEB-44842).
8. Prefer using double quotes. 

# Testing

> How will the project be tested?

The document will be reviewed by the team.

# Alternatives Considered

> Summarize alternative designs (pros & cons)

1. Don't specify code style
- Pros:
    1. Save creating documentation and maintaining it.
- Cons:
    1. We'll notice different approaches used and code will be less 
    readable due to the different styles used.
    2. Potential frustration due to unspecified style approaches.

# Timeline

> Document milestones and deadlines.

DONE:

  - Initial Unit testing documentation description rules.

NEXT:

  - Add more Dart/Flutter style clarifications.
  
# Results

> What was the outcome of the project?

Consistent code style used on all Dart codebases.