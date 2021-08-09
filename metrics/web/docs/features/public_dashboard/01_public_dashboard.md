# Public Dashboard
> Feature description / User story.

As a user, I want to be able to enable public access to the dashboard page in my `Metrics Web` application instance for everyone.

## Contents

- [**Analysis**](#analysis)
    - [Feasibility study](#feasibility-study)
    - [Requirements](#requirements)
    - [Landscape](#landscape)
        - [Saving public dashboard configuration](#Saving-public-dashboard-configuration)
        - [Disabling the authentication in the Metrics Web application](#Disabling-the-authentication-in-the-Metrics-Web-application)
            - [Do not authenticate the user](#Do-not-authenticate-the-user)
            - [Authenticate as an anonymous user](#Authenticate-as-an-anonymous-user)
    - [Prototyping](#prototyping)
    - [System modeling](#system-modeling)
- [**Design**](#design)
    - [Architecture](#architecture)
    - [User Interface](#user-interface)
    - [Data Storage](#data-storage)
        - [Storing the public dashboard configuration](#storing-the-public-dashboard-configuration)
        - [Accessing the data using the anonymous user](#accessing-the-data-using-the-anonymous-user)
    - [Privacy](#privacy)
    - [Security](#security)
    - [Program](#program)
        - [FeatureConfig module](#featureconfig-module)
            - [PublicDashboardFeatureConfigModel](#PublicDashboardFeatureConfigModel) 
            - [FeatureConfig module changes](#featureconfig-module-changes)
        - [Auth module](#auth-module)
            - [UserProfileViewModel](#UserProfileViewModel)
            - [SignInAnonymouslyUseCase](#SignInAnonymouslyUseCase)
            - [AuthState](#AuthState)
            - [Auth module changes](#auth-module-changes)
        - [Navigation module](#navigation-module)
            - [Navigation module changes](#navigation-module-changes)  
        - [Making things work](#making-things-work) 
            - [Auto sign in the user anonymously](#auto-sign-in-the-user-anonymously)
            - [Manage sign in for the anonymous user](#manage-sign-in-for-the-anonymous-user)
            - [Change the Metrics user menu UI](#change-the-metrics-user-menu-ui)
    - [Testing](#testing)

# Analysis
> Describe a general analysis approach.

During the analysis process, we are going to review all approaches we can apply during the development and define requirements for the Public Dashboard feature.

### Feasibility study
> A preliminary study of the feasibility of implementing this feature.

Since the `Metrics Web` application allows tracking the project metrics, it may be useful for users to be able to access these metrics without any authentication. For example, authors of an open-source project can leave a link to the project metrics in a readme file and so the users can access the dashboard.

### Requirements
> Define requirements and make sure that they are complete.

This feature should accept the following requirements: 

- The public dashboard feature should be configurable within the Metrics Web application instance.
- The dashboard page should be opened without authentication if the public dashboard feature is enabled.
- The information on the dashboard page should be available without authentication if the public dashboard feature is enabled.
- The project groups page is not available for an unauthenticated user even if the public dashboard feature is enabled.
- An unauthenticated user should be able to sign in to the Metrics Web application using the `Sign in` option in the user menu.

### Landscape
> Look for existing solutions in the area.

To implement this feature, we should decide which approach we are going to use for the following use cases: 

- [Saving public dashboard configuration](#Saving-public-dashboard-configuration). 
- [Disabling the authentication in the `Metrics Web` application](#Disabling-the-authentication-in-the-Metrics-Web-application).

Let's consider the landscape for these use cases separately: 

#### Saving public dashboard configuration 
> Look for existing solutions for saving the public dashboard configuration.

Since enabling and disabling the public dashboard in the `Metrics Web` application is a feature configuration, we are going to store this configuration according to the [Feature Config](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/features/feature_config/01_feature_config_design.md) design document - in the `feature_config` document under the `feature_config` collection in the Firestore database.

#### Disabling the authentication in the Metrics Web application
> Look for existing solutions for disabling the authentication in the Metrics Web applicaiton.

We have the following approaches for disabling the authentication in the `Metrics Web` application: 

- [Do not authenticate the user](#Do-not-authenticate-the-user) if the public dashboard is enabled.
- [Authenticate the user as an anonymous one](#Authenticate-as-an-anonymous-user) when the application opens if the public dashboard is enabled.

Let's consider these approaches and their pros and cons: 

##### Do not authenticate the user
> Describe the approach and provide its pros and cons.

The first approach implies the full disabling of the authentication feature and allowing the user to access the `Metrics Web` application dashboard page without logging in. 

Let's review the pros and cons of this approach: 

Pros: 
- Does not store any user information (like a selected theme) in the database if the user is not authenticated.

Cons: 
- Requires significant changes in the Firebase security rules.
- Complexifies Firestore Security rules testing and maintaining.
- Requires more boilerplate code to implement the feature.
- Requires additional mechanism of saving the user-selected theme.
- Requires additional changes to the code related to the app navigation.
- Does not allow using Firebase Analytics.

##### Authenticate as an anonymous user
> Describe the approach and provide its pros and cons.

Another approach is to use the `Firebase` anonymous users if the public dashboard is enabled. It means that we will log in users anonymously on the application opening.

Let's review what does anonymous log-in means. It means that we are creating a user record in the Firebase without having any information about the user like email, password, etc. Since there is no need for user interaction (like entering any email/password and so on) to log in anonymously, we can make it automatically on application startup. Once the user logs in anonymously, the `FirebaseAuth.onAuthStateChanged` emits a new anonymous user. The anonymous user has an identifier that allows us to create a user profile and save the user-specific data as if a user would log in as usual.

Also, according to the [Firebase Authentication](https://firebase.flutter.dev/docs/auth/usage/#anonymous-sign-in) documentation, the user is saved through application sessions. It means that the user doesn't lose their data, like selected theme, on application closes or browser page refreshes. The initially created anonymous account will not persist on the next sign-in in the following cases:

- The user signed out from the anonymous account.
- The user clears their browser storage.
- The user opens the application using the private browsing method (for example, using incognito mode in the Google Chrome browser).

Consider the pros and cons of this approach: 

Pros: 
- Requires minimal changes in Firebase security rules.
- Does not require changes in saving the user-selected theme.
- Requires minimal changes in the currently existing codebase.
- Leaves an ability to gather analytics for non-authenticated users (authenticated anonymously).

Cons:
- Still saves the user information to the Firestore.
- May significantly increase the number of user profiles stored in the Firestore database.

Since using the Firebase anonymous user allows us to not change the process of storing the user information like selected theme and requires minimal changes in the existing codebase, we are going to use an existing approach with the Firebase anonymous user.

### Prototyping
> Create a simple prototype to confirm that implementing this feature is possible.

To provide the authentication feature config, we should be able to authenticate a user as an anonymous one on the application startup. Since the `Metrics Web` application has initializing phase on application startup, we can log in users on this phase. 

Let's review the code snippet showing the process of authenticating the user as an anonymous one: 

```dart
final firebaseAuth = FirebaseAuth.instance;

await firebaseAuth.signInAnonymously();
```

Once we've figured out that we can sign in anonymously, let's consider the code snippet proving that we are able to detect whether the Firebase user is anonymous: 

```dart
final user = await firebaseAuth.currentUser();

final isAnonymous = user.isAnonymous;
```

Since we can log in users without any user interaction and check whether the user is anonymous, we can state that the feature implementation is possible. 

### System modeling
> Create an abstract model of the system/feature.

Once we've chosen the implementation approach, let's consider the components diagram displaying the components that should be added/modified to implement this feature: 

![Auth Feature Disabling Components](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/web/docs/features/public_dashboard/diagrams/public_dashboard_components.puml)

# Design

The following sections explains the implementation details of the public dashboard feature.

### Architecture
> Fundamental structures of the feature and context (diagram).

Once we've chosen the implementation approach of the public dashboard, let's review the main points this feature architecture requires:
- Add the ability to sign in anonymously into the `AuthNotifier`.
- Subscribe the `AuthNotifier` to the `FeatureConfigNotifier` so the first one is able to take the public dashboard feature state from the last one that allows the `AuthNotifier` to handle anonymous sign in by itself.
- Subscribe the `NavigationNotifier` to the `AuthNotifier` so the `NavigationNotifier` can take the current user auth state from the `AuthNotifier`, which in turn allows the `NavigationNotifier` to navigate depending on this value.

Consider the following diagram that briefly describes this architecture approach:

![Public Dashboard Architecture Components Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/public_dashboard_design/metrics/web/docs/features/public_dashboard/diagrams/public_dashboard_architecture_components_diagram.puml)

### User Interface
> How users will interact with the feature (API, CLI, Graphical interface, etc.).

As we've mentioned above, the non-authorized users should not be able to access the `Project Groups` page. Because of this, we should hide this option from the user menu for anonymous users. Also, there should be an ability to sign in for anonymous users, so we should change the `Logout` button from the user menu to the `Sign in` one. 

Let's consider the user menu UI in case we are using an anonymous user: 

![Anonymous User Menu](images/menu.png)

### Data Storage
> How relevant data will be persisted and protected.

The public dashboard menu requires changes in the `Firestore` database that can be divided into two different parts:

- [Storing the public dashboard configuration](#storing-the-public-dashboard-configuration).
- [Accessing the data using the anonymous user](#accessing-the-data-using-the-anonymous-user).

Let's consider each of them in more detail: 

#### Storing the public dashboard configuration
> Explain the way we are going to store the public dashboard configuration.

As we've mentioned above, we are going to store the public dashboard configuration as a [Feature Config](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/features/feature_config/01_feature_config_design.md) - in the `feature_config` document, under the `feature_config` collection. So, let's review the `feature_config` document structure, including the `public dashboard` configuration: 

```json
{
    isDebugMenuEnabled: bool,
    isPasswordSignInOptionEnabled: bool,
    isPublicDashboardEnabled: bool
}
```

Since these changes do not require creating any new collections/documents, the Firestore Security rules should not be changed. 

#### Accessing the data using the anonymous user
> Explain the changes required to make the data accessible for anonymous users.

There is no need to change the `Firestore` database structure to access the data using the anonymous user. 
But we should change the `Firestore` security rules for managing anonymous users' data access. Please, consider the following [section](#Security) to learn more about these `Firestore` security rules. 

### Privacy
> Privacy by design. Explain how privacy is protected (GDPR, CCPA, HIPAA, etc.).

When introducing the feature, we should pay attention to the privacy of the affected data. The integrating of the public dashboard feature makes the dashboard data available for all users if the feature is enabled, but since the data from the dashboard is not affected by the following rules: GDPR, CCPA, etc, we don't have to request users' permission to collect and process this kind of data.

### Security
> How relevant data will be secured (Data encryption at rest, etc.).

After introducing the public dashboard feature, we receive a new user authentication state (`anonymous user`), so we have to revise the `Firestore` security rules and add rules for this `anonymous user`.

The following table describes the `Firestore` security rules for the `anonymous user` (`+` means that the operation is allowed, `-` means that the operation is prohibited):

| Collection name | Create | Read | Update | Delete |
| --------------- | ------ | ---- | ------ | ------ |
| `projects` | - | + | - | - |
| `builds`| - | + | - | - |
| `project_groups` | - | + | - | - |
| `user_profiles` | + (only owner) | + (only owner) | + (only owner) | - |
| `build_days` | - | + | - | - |

Please, note that if the collection is not mentioned in the table above, the collection rules should stay as is.

### Program
> Detailed solution description to class/method level.
 
The implementation of the public dashboard feature involves the changes in the following modules:

- The [`feature config` module](#featureconfig-module).
- The [`auth` module](#auth-module).
- The [`navigation` module](#navigation-module).

Consider the following subsections that describe each module changes in more detail.

#### FeatureConfig module

The first important part is adding the ability to track the feature state. It will allow us to change the behavior of our application correspondingly. For this purpose, we should implement a `PublicDashboardFeatureConfigModel` class and make changes to this module. The following subsections describe in a bit more detail this class and the changes required for the feature integration.

##### PublicDashboardFeatureConfigModel
> Explain the purpose and responsibility of the class.

As mentioned above, we are going to store the public dashboard feature configuration in the Firestore database. The `FeatureConfigNotifier` manages the application state related to the feature configuration, so this class will hold the current value of this feature configuration. To be able to transfer the data between the states, according to the [Presentation Layer Architecture](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/02_presentation_layer_architecture.md#model) document, we should use the model classes. So, for this purpose, we should create a `PublicDashboardFeatureConfigModel` that will be used to transfer the public dashboard feature configuration between application states (`ChangeNotifier`s).

##### FeatureConfig module changes

Consider the list of changes this module requires to integrate the public dashboard feature:
- Add the `isPublicDashboardFeatureEnabled` boolean field to the `FeatureConfig` model.
- Change the `FeatureConfigData`'s `fromJson()` and `toJson()` methods, so they include handling the new added field.
- Create the [`PublicDashboardFeatureConfigModel`](#PublicDashboardFeatureConfigModel) and initialize it in the `FeatureConfigNotifier`.

Let's review the following class diagram, which describes the relationship between the classes in this module:

![Feature Config Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/public_dashboard_design/metrics/web/docs/features/public_dashboard/diagrams/public_dashboard_feature_config_class_diagram.puml)

#### Auth module

Next, we should add the ability to sign in anonymously and detect the user type. Review sections below that describe changes needed to implement this functionality.

##### UserProfileViewModel
> Explain the purpose and responsibility of the class.

Since we want to disable some features on the UI when the user is anonymous, we should be able to access the user profile from the UI. As the [Presentation Layer Architecture](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/02_presentation_layer_architecture.md#view-model) document states, we should create a `view model` to be able to access the data from the `state` on the UI. So, we should create a view model representing a user profile to disable the `Project Groups` page and provide the ability to `Sign In` to the application for the anonymous users.

##### SignInAnonymouslyUseCase
> Explain the purpose and responsibility of the class.

Since the public dashboard feature implies logging in as an anonymous user, we should create a use case needed to log in to the application using the anonymous user.

##### AuthState
> Explain the purpose and responsibility of the class.

Since we should know the authentication state of the user, we should provide an enum that will contain all the following states:
- loggedIn
- loggedInAnonymously
- loggedOut

##### Auth module changes

Let's consider the list of changes this module requires to integrate the public dashboard feature:
- Add the `signInAnonymously()` method to the `UserRepository` abstract class.
- Add the implementation of the `signInAnonymously()` method to the `FirebaseUserRepository` class.
- Add the `isPublicDashboardFeatureEnabled` field of the boolean type to the `AuthNotifier`.
- Add the `isInitialized` getter of the boolean type to the `AuthNotifier`.
- Add the `handlePublicDashboardFeatureConfigUpdates()` to the `AuthNotifier`, so we can handle the feature state updates.
- Create the [`UserProfileViewModel`](#UserProfileViewModel) class.
- Create the [`SignInAnonymouslyUseCase`](#SignInAnonymouslyUseCase) class, which calls the `signInAnonymously()` method of the `UserRepository`.
- Create the [`AuthState`](#AuthState) enum.
- Integrate the view model, the use case, and the enum described above into the `AuthNotifier`.

Let's review the following class diagram, which describes the relationship between the classes in this module:

![Auth Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/public_dashboard_design/metrics/web/docs/features/public_dashboard/diagrams/public_dashboard_auth_class_diagram.puml)

#### Navigation module

The last thing, we should have the ability to manage the navigation of the anonymous user, that is, to know which pages they can visit and which they can't. The next subsection describes changes that we should implement to integrate the public dashboard feature.

##### Navigation module changes

Please consider the following list of changes this module requires to integrate the public dashboard feature:
- Add the `authState` field of the `AuthState` type to the `NavigationNotifier`.
- Add the `handleAuthUpdates()` method to the `NavigationNotifier`, which should handle the updating of the `AuthState` in the `AuthNotifier`.
- Add the `allowsAnonymousAccess` field of the `bool` type to the `RouteConfiguration` class and configure the `allowsAnonymousAccess` value in the `RouteConfiguration` constructor for each page;  
- Add the additional condition to the `_processConfiguration()` method, which should state the following, if the user auth state is logged in anonymously, and the `allowsAnonymousAccess` field of the `RouteConfiguration` is true, then return the current page configuration.

#### Making things work

After the changes in the modules above, let's move on to integrating these changes into the application.

Here are the main parts that we should add to the application:
- [Auto sign in the user anonymously](#auto-sign-in-the-user-anonymously) if the feature is enabled.
- [Manage sign in for the anonymous user](#manage-sign-in-for-the-anonymous-user).
- [Change the Metrics user menu UI](#change-the-metrics-user-menu-ui).

Let's review each of the above points in the following subsections

##### Auto sign in the user anonymously

To auto sign in the user anonymously, we should make the following:
1. The `handleAuthUpdates()` method of the `NavigationNotifier` should be called when the `AuthNotifier.authState` changes.
2. The `handlePublicDashboardFeatureConfigUpdates()` method of the `AuthNotifier` should be called when the `FeatureConfigNotifier.publicDashboardFeatureConfigModel` changes.
3. Add the logic of the signing the user in anonymously depending on the `AuthNotifier.isPublicDashboardFeatureEnabled` and the `AuthNotifier.authState` to the `AuthNotifier`.
4. Add the logic of the navigating depending on the `AuthNotifier.authState` to the `NavigationNotifier`.

_**Note:** The `handleAuthUpdates()` does nothing if the `AuthNotifier.authState` equals to the `AuthState.loggedIn`, because we handle this case in the `LoginPage` class._

##### Manage sign in for the anonymous user

The next one, to manage the sign-in for the anonymous user (f.e. sign in with credentials or using Google provider), we have to sign in them using one of the sign methods mentioned above, then the Firebase auth, for its part, replaces the current user with a new one without any problems.

##### Change the Metrics user menu UI

The last thing we should change the Metrics user menu UI accordingly to the [User Interface section](#user-interface). For this purpose, we should take the [`UserProfileViewModel`](#UserProfileViewModel) from the `AuthNotifier` and disable the specified parts in the UI based on the view model value. 

Consider the overall class diagram for the public dashboard feature that describes the relationships between the classes this feature requires:

![Public Dashboard Feature Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/public_dashboard_design/metrics/web/docs/features/public_dashboard/diagrams/public_dashboard_class_diagram.puml)

Consider the overall sequence diagram for the public dashboard feature that describes the main flow for the public dashboard feature:

![Public Dashboard Feature Sequence Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/public_dashboard_design/metrics/web/docs/features/public_dashboard/diagrams/public_dashboard_sequence_diagram.puml)

### Testing
> Describe an approach on how the feature should be tested.

To test the feature, we should focus on the following types of tests:
- The unit tests, which cover the main logic of the feature, described in the [program section](#program).
- The widget tests, which test that the UI behaviour corresponds to the expectations from the [User Interface section](#user-interface).
- The integration tests, which test how individual pieces work together as a whole running on a real device.

Also, since we're going to change the Firebase security rules accordingly to the security section, we should cover these rules with the unit tests.
