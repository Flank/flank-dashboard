# Public Dashboard
> Feature description / User story.

As a user, I want to be able to disable the authentication in my `Metrics Web` application instance to allow access for everyone.

## Contents

- [**Analysis**](#analysis)
    - [Feasibility study](#feasibility-study)
    - [Requirements](#requirements)
    - [Landscape](#landscape)
        - [Saving authentication enabled configuration](#Saving-authentication-enabled-configuration)
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

- The user should be able to configure whether the authentication feature is enabled in the `Metrics Web` application instance.
- The `Metrics Web` application should work the same with enabled and disabled authentication. 
- If the authentication is disabled, not logged in users should have access to the `Metrics Web` application as if they were logged in.
- The user-selected theme should be stored if the user is not authenticated.

### Landscape
> Look for existing solutions in the area.

To implement this feature, we should decide which approach we are going to use for the following use cases: 

- [Saving authentication enabled configuration](#Saving-authentication-enabled-configuration). 
- [Disabling the authentication in the `Metrics Web` application](#Disabling-the-authentication-in-the-Metrics-Web-application).

Let's consider the landscape for these use cases separately: 

#### Saving authentication enabled configuration 
> Look for existing solutions for saving the authentication enabled configuration.

Since enabling and disabling the authentication in the `Metrics Web` application is a feature configuration, we are going to store the data according to the [Feature Config](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/features/feature_config/01_feature_config_design.md) design document - in the `feature_config` document under the `feature_config` collection in the Firestore database.

#### Disabling the authentication in the Metrics Web application
> Look for existing solutions for disabling the authentication in the Metrics Web applicaiton.

We have the following approaches for disabling the authentication in the `Metrics Web` application: 

- [Do not authenticate the user](#Do-not-authenticate-the-user) if the authentication is disabled.
- [Authenticate the user as an anonymous one](#Authenticate-as-an-anonymous-user) when the application opens if the authentication is disabled.

Let's consider these approaches and their pros and cons: 

##### Do not authenticate the user
> Describe the approach and provide its pros and cons.

The first approach implies the full disabling of the authentication feature and allowing the user to access the `Metrics Web` application without logging in. 

Let's review the pros and cons of this approach: 

Pros: 
- Do not store any user information (like a selected theme) in the database if the authentication is disabled.
- Requires minimal changes in the `CI Integrations` module to support disabled authentication.

Cons: 
- Requires changes in the Firebase security rules.
- Requires more code to implement the feature.
- Requires additional mechanism of saving the user-selected theme.

##### Authenticate as an anonymous user
> Describe the approach and provide its pros and cons.

Another approach is to use the `Firebase` anonymous users if the authentication is disabled. It means that we will log in users anonymously on the application opening.

Let's review what does anonymous log-in means in a bit more detail. Once the user logs in anonymously, the `FirebaseAuth.onAuthStateChanged` emits a new anonymous user. The anonymous user has an identifier that allows us to create a user profile and save the user-specific data as if a user would log in without any changes in the codebase. Also, according to the [Firebase Authentication](https://firebase.flutter.dev/docs/auth/usage/#anonymous-sign-in) documentation, the user will be saved through application sessions. It means that the user won't lose its data, like selected theme, on application closing or browser page refresh. The initially created anonymous account will not persist on the next sign-in in the following cases: 

- User signed out from the anonymous account
- User clears their browser storage
- User opens the application using the private browsing method, for example, using incognito mode in the Google Chrome browser.

Consider the pros and cons of this approach: 

Pros: 
- Requires minimal changes in Firebase security rules.
- Do not require changes in saving the user-selected theme. 
- Requires minimal changes in the currently existing codebase.
- Leaves an ability to gather analytics when the authentication is disabled.

Cons:
- Still saving the user information to the Firestore. 
- Requires changes in the `CI Integrations` to support disabled authentication.

Since using the Firebase anonymous user allows us to not change the Firebase security rules and requires minimal changes in the existing codebase, we are going to use an existing approach with the Firebase anonymous user.

### Prototyping
> Create a simple prototype to confirm that implementing this feature is possible.

To provide the authentication feature config, we should be able to authenticate a user as an anonymous one on the application startup. Since the `Metrics Web` application has initializing phase on application startup, we can log in users on this phase. 

Let's review the code snippet showing the process of authenticating the user as an anonymous one: 

```dart
final firebaseAuth = FirebaseAuth.instance;

await firebaseAuth.signInAnonymously();
```

Since we can log in users without any user interaction, we can state that the feature implementation is possible. 

### System modeling
> Create an abstract model of the system/feature.

Once we've chosen the implementation approach, let's consider the components diagram displaying the components that should be added/modified to implement this feature: 

![Auth Feature Disabling Components](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/public_dashboard_analysis/metrics/web/docs/features/public_dashboard/diagrams/public_dashboard_components.puml)

