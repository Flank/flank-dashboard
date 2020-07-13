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
9. DO NOT use "should" in test descriptions
    
    `Good:`
         
    ```dart
    test(".fromJson() creates an instance from the json map", () {
    ```
    
    `Bad:`
              
    ```dart
    test(".fromJson() should create an instance from the json map.", () {
    ```
    Additional information: 
    - https://enterprisecraftsmanship.com/posts/you-naming-tests-wrong/
    - https://medium.com/frontmen/remove-the-verb-should-from-your-unit-test-descriptions-please-ee3a58f3dda0
    
10. DO NOT document Mock classes
    
    `Good:`
    
    ```dart
    class SourceClientMock extends Mock implements SourceClient {}
    ```
    
    `Bad:`
              
    ```dart
    /// This class mocks [SourceClient] to help with testing.
    class SourceClientMock extends Mock implements SourceClient {}
    ```
    
11. DO document Mock static fields
    
    Though it is assumed that Mock classes do not have any fields, sometimes it appears to be very pragmatic to add some _static_ fields to them in order to simplify code and tests structure, follow DRY or KISS, etc. (see Dart Mockito [best practices](https://pub.dev/packages/mockito#best-practices))
     
    `Good:`

    ```dart
    class CoolClassMock extends Mock implements CoolClass {
      /// The really useful field that allows doing something extra-cool 
      /// in order to prevent something very bad.
      static const String reallyUsefulField = 'Really Useful Value';
    ```

    `Bad:`

    ```dart
    class CoolClassMock extends Mock implements CoolClass {
      static const String reallyUsefulField = 'Really Useful Value';
    ```
12. DO NOT document Fake classes

    `Good:`
    
    ```dart
    class SignedInAuthStoreFake extends Fake implements AuthStore {
    ```
    
    `Bad:`
              
    ```dart
    /// Fake implementation of the [AuthStore] ensures that a user is already logged in into the app.
    class SignedInAuthStoreFake extends Fake implements AuthStore {
    ```
13. DO document Fake custom properties

    `Good:`
    
    ```dart
    class SignedInAuthStoreFake extends Fake implements AuthStore {
      /// Internal stream used to support [AuthStore] functionality.
      final BehaviorSubject<bool> _isLoggedInSubject = BehaviorSubject();
    ```
    
    `Bad:`
              
    ```dart
    class SignedInAuthStoreFake extends Fake implements AuthStore {
      final BehaviorSubject<bool> _isLoggedInSubject = BehaviorSubject();
    ```

14. DO document Testbeds, Stubs, etc. used in testing
    
    `Good:`
        
    ```dart
    /// A stub class for a [CiConfig] abstract class providing required
    /// implementations.
    class CiIntegrationStub extends CiIntegration {
    ```
    
    `Bad:`
          
    ```dart
    class CiIntegrationStub extends CiIntegration {
    ```
15. AVOID document fields of classes providing test data

    `Good:`
        
    ```dart
    /// A class containing a test data for the [JenkinsSourceConfig].
    class JenkinsConfigTestData {
      static const String url = 'url';
    ```
    
    `Bad:`
          
    ```dart
    /// A class containing a test data for the [JenkinsSourceConfig].
    class JenkinsConfigTestData {
      /// Test URL used for Jenkins configuration.
      static const String url = 'url';
    ```

  ## Immutable classes

  1. PREFER using the `@immutable` annotation for immutable classes.

      `Good:`

      ```dart
      /// A view model class with the build number metric data.
      @immutable
      class BuildNumberScorecardViewModel {
        /// A number of builds to display.
        final int numberOfBuilds;

        /// Creates the [BuildNumberScorecardViewModel] instance with
        /// the given [numberOfBuilds].
        const BuildNumberScorecardViewModel({
          this.numberOfBuilds,
        });
      }
      ```

      `Bad:`

      ```dart
      /// A view model class with the build number metric data.
      class BuildNumberScorecardViewModel {
        /// A number of builds to display.
        final int numberOfBuilds;

        /// Creates the [BuildNumberScorecardViewModel] instance with
        /// the given [numberOfBuilds].
        const BuildNumberScorecardViewModel({
          this.numberOfBuilds,
        });
      }
      ```
    
  
  2. AVOID using the `@immutable` annotation when extending or implementing an immutable classes.

      `Good:`

      ```dart
      /// A view model that contains the data for the percent displaying widgets.
      class PercentViewModel extends Equatable {
      ```
      
      `Bad:`

      ```dart
      /// A view model that contains the data for the percent displaying widgets.
      @immutable
      class PercentViewModel extends Equatable {
      ```
  
  3. DO use the `immutable` collections in classes extending `Equatable`.

      `Good:`

      ```dart
      /// A view model that represents the data of the performance metric to display.
      class PerformanceSparklineViewModel extends Equatable {
        /// A list of points representing the performance of the project builds.
        final UnmodifiableListView<Point<int>> performance;
      ```
      
      `Bad:`

      ```dart
      /// A view model that represents the data of the performance metric to display.
      class PerformanceSparklineViewModel extends Equatable {
        /// A list of points representing the performance of the project builds.
        final List<Point<int>> performance;
      ```
  

# Testing

> How will the project be tested?

The team will review the document and provide feedback.

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
