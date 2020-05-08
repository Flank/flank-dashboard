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

## Test descriptions
1. DO NOT end descriptions with a dot (.)
    
    `Good:`
              
    ```dart
    test(".fromJson() creates an instance from the json map", () {
    ```
   
   `Bad:`
               
   ```dart
   test('.fromJson() creates an instance from the json map.', () {
   ```
2. DO start Test Group descriptions with a Capital letter
    
    `Good:`
    
    ```dart
    group("DashboardPage", () {
    ```
3. DO start with a small letter test descriptions inside Test Groups

    `Good:`
    
    ```dart
    group("DashboardPage", () {
      test("throws ArgumentError trying to create an instance with null CI client", 
    ```
4. DO start with a Capital letter test descriptions not inside Test Groups
    
    `Good:`
    
    ```dart
    testWidgets("Can't create widget without data",
   ```
5. DO start test descriptions with a dot (.) followed by a method name with an empty parenthesis 
(without parameters even if there are any) when a test is specific for a method (or named constructor)

    `Good:`
    
    ```dart
    test(".fromJson() creates an instance from the json map", () {
    ```
6. DO use Test Group descriptions with class under test name
    
    `Good:`
    
    ```dart
    group("ReceiveProjectMetricUpdates", () {
       .....
       test("loads all fields in the performance metrics", () {
    ```
7. DO NOT use multiline test descriptions as such tests can't 
be started in [Intellij](https://youtrack.jetbrains.com/issue/WEB-44842)
    
    `Good:`
            
    ```dart
    test(".fromJson() creates an instance from the json map", () {
    ```
   
   `Bad:`
               
   ```dart
   test('.fromJson() creates an instance'
        'from the json map', () {
   ```
8. PREFER using double quotes in test descriptions
    
    `Good:`
    
    ```dart
    test(".fromJson() creates an instance from the json map", () {
    ```

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