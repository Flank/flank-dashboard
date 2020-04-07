# Dart code style
> Summary of the proposed change

Make sure that our code style is consistent for parts that are not covered in Dart code style.

# References
> Link to supporting documentation, GitHub tickets, etc.

- [Effective Dart](https://dart.dev/guides/language/effective-dart/) is the main source for 
all code style, documentation, design and usage conventions.


# Motivation
> What problem is this project solving?

As Dart has a great code styleavailable
that we use on this project we noticed that in some real-world cases there is no guidance,
so here we collect all cases that we think important to clarify to make sure that the code style
is consistent through the project.

# Goals

> Identify success metrics and measurable goals.

Have a document that can be used in code reviews to clarify code style issues and make sure
that code style is consistent.

# Non-Goals

> Identify what's not in scope.

- Other languages we might use (Bash scripts, JavaScript)

# Documentation

## Unit tests
1. Test Group description starts with Capital letter

    group("DashboardPage", () {

2. Test description inside group starts with small letter

    test("should throw ArgumentError trying to create an instance with null CI client", 

3. test description not inside test group starts with Capital letter.
    testWidgets("Can't create widget without data",
4. Group and test descriptions should not end with dot (.).
5. If method name (or named constructor) is used in test description it should start with dot (.)
and should have parenthesis
    test(".fromJson() should create an instance from the json map", () {
6. Use group with class under test name
group("ReceiveProjectMetricUpdates", () {
    .....
    test("loads all fields in the performance metrics", () {
7. Multiline strings shouldn't be used as documentation is not properly generated 
TODO: add github issue
8. Prefer using double quotes in strings - add why
