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

# Analysis
> Describe a general analysis approach.

During the analysis process, we are going to overview all approaches we can apply during the development and define requirements for this feature.

### Feasibility study
> A preliminary study of the feasibility of implementing this feature.

Since the `Metrics Web` application allows tracking the project metrics, it may be useful for users to be able to access the metrics without any authentication, for example, for open-source projects, to be able to leave a link to the project metrics in a readme file.

### Requirements
> Define requirements and make sure that they are complete.

This feature should accept the following requirements: 

- There should be an ability to configure whether the public dashboard feature is enabled in the `Metrics Web` application instance.
- If the public dashboard is enabled, the dashboard page should be opened on the application open, avoiding the login page.
- If the user is not logged in, he should be able to view the information on the dashboard page. 
- If the user is not logged in, he should not be able to open the project groups page.
- The not-authenticated user should be able to sign in to the application by selecting the `Sign in` option in the user menu. 

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
- Do not store any user information (like a selected theme) in the database if the user is not authenticated.

Cons: 
- Requires significant changes in the Firebase security rules.
- Requires more code to implement the feature.
- Requires additional mechanism of saving the user-selected theme.
- Do not allow using the Firebase analytics.

##### Authenticate as an anonymous user
> Describe the approach and provide its pros and cons.

Another approach is to use the `Firebase` anonymous users if the public dashboard is enabled. It means that we will log in users anonymously on the application opening.

Let's review what does anonymous log-in means. Once the user logs in anonymously, the `FirebaseAuth.onAuthStateChanged` emits a new anonymous user. The anonymous user has an identifier that allows us to create a user profile and save the user-specific data as if a user would log in as usual. Also, according to the [Firebase Authentication](https://firebase.flutter.dev/docs/auth/usage/#anonymous-sign-in) documentation, the user will be saved through application sessions. It means that the user won't lose its data, like selected theme, on application closing or browser page refresh. The initially created anonymous account will not persist on the next sign-in in the following cases: 

- The user signed out from the anonymous account.
- The user clears their browser storage.
- The user opens the application using the private browsing method, for example, using incognito mode in the Google Chrome browser.

Consider the pros and cons of this approach: 

Pros: 
- Requires minimal changes in Firebase security rules.
- Do not require changes in saving the user-selected theme. 
- Requires minimal changes in the currently existing codebase.
- Leaves an ability to gather analytics for not authenticated users.

Cons:
- Still saving the user information to the Firestore. 

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

![Auth Feature Disabling Components](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/public_dashboard_analysis/metrics/web/docs/features/public_dashboard/diagrams/public_dashboard_components.puml)

