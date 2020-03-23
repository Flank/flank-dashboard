# Firebase SDK configuration

> Summary of the proposed change

Describes how to add a manual configuration of the Firebase SDK to the Flutter Web application.

# References

> Link to supporting documentation, GitHub tickets, etc.

- [Firebase console](https://console.firebase.google.com/)

# Motivation

> What problem is this project solving?

Explains how to add manual configuration of the Firebase SDK to the Flutter Web application.

# Goals

> Identify success metrics and measurable goals.

- The Flutter Web application runs whether on remote server or locally
 and connects to the configured Firebase project.

# Non-Goals

> Identify what's not in scope.

Adding Firebase SDK auto-config is out of scope.

# Design

> Explain and diagram the technical design

`Flutter Web app` -> `Firebase SDK configuration` -> `Firestore Database`

> Identify risks and edge cases

Even if you'll redeploy your application to another Firebase project,
 it works with the given Firestore database until you change the configuration in the `web/index.js` file.

# API

> What will the proposed API look like?

## Before you start

To configure Firebase SDK you need to have a configured Firebase project and Firestore database.
For more details see [Metrics firebase deployment](https://github.com/software-platform/monorepo/blob/firebase_deployment_instructions/docs/09_firebase_deployment.md#creating-new-firebase-project) document.

## Configuring the Flutter for Web application

Follow the next steps to add manual configuration of the Firebase SDK to your Flutter application: 

1. Open the [Firebase console](https://console.firebase.google.com/), choose your project 
and go to the project setting (tap on the setting gear icon near the `Project Overview` on top of the left panel and select `Project settings`.
2. Scroll down and find your Firebase Web Application. 
3. Go to `Firebase SDK snippet` of your application, select `Config` and copy the generated code.
4. Go to the `web/index.js` file in the application directory and replace these code:
    ```
    <script src="/__/firebase/7.12.0/firebase-app.js"></script>
    <script src="/__/firebase/7.12.0/firebase-firestore.js"></script>
    <script src="/__/firebase/init.js"></script>
    ```
    with the following code: 
    ```
      <script src="https://www.gstatic.com/firebasejs/7.12.0/firebase-app.js"></script>
      <script src="https://www.gstatic.com/firebasejs/7.12.0/firebase-firestore.js"></script>

      <script>
        // Your web app's Firebase configuration
        var firebaseConfig = {
          <your firebase config copied in step 4>
        };

        firebase.initializeApp(firebaseConfig);
      <script>
    ```

Done! The Firebase SDK is configured and will use the Firestore Database from the given Firebase project.
 Also, you can run your application locally, with the `flutter run -d chrome` command or from your IDE.

# Dependencies

> What is the project blocked on?

This project depends on Firebase configuration, described in the [Metrics Firebase deployment](https://github.com/software-platform/monorepo/blob/firebase_deployment_instructions/docs/09_firebase_deployment.md#creating-new-firebase-project) document.

> What will be impacted by the project?

Nothing will be impacted by this project.

# Testing

> How will the project be tested?

This project will be tested manually by running the application and checking 
if the application has access to the database.

# Alternatives Considered

> Summarize alternative designs (pros & cons)

No alternatives considered.

# Timeline

> Document milestones and deadlines.

DONE:

  - The manual configuration is added to the Flutter Web application and the
   application connects to the given Firebase project.
  
# Results

> What was the outcome of the project?

Flutter web application is configured, runs whether on remote server or locally,
 and connects to the given Firebase application.