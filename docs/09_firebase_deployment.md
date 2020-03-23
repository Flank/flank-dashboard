# Metrics firebase deployment

> Summary of the proposed change

Describe the process of deployment of the Metrics application to the Firebase Hosting
 and deploying the Cloud functions needed to create test data for the application.


# References

> Link to supporting documentation, GitHub tickets, etc.

- [Getting started with Firestore](https://cloud.google.com/firestore/docs/client/get-firebase)
- [Deploying to firebase hosting](https://firebaseopensource.com/projects/firebase/emberfire/docs/guide/deploying-to-firebase-hosting.md/)
- [Getting started with Firebase Cloud Functions](https://firebase.google.com/docs/functions/get-started)

# Motivation

> What problem is this project solving?

Have the Metrics application with test data accessible using a link.

# Goals

> Identify success metrics and measurable goals.

- Web application deployed to Firebase Hosting and available for everyone on the link.
- Deployed Cloud functions for creating test data.

# Non-Goals

> Identify what's not in scope.

Deployment to other platforms is out of scope.

# Design

> Explain and diagram the technical design

`Metrics Web Source` -> `Compile` -> `Deploy` ->  `Firebase Hosting`

`Metrics Web Cloud Functions` -> `Deploy` -> `Firebase Cloud Functions`

> Identify risks and edge cases

# API

> What will the proposed API look like?


## Before you begin

You should have installed before you start: 

1. [Flutter](https://flutter.dev/docs/get-started/install) v1.15.3.
2. [npm](https://www.npmjs.com/get-npm).

## Creating new Firebase project.

1. Go to [Firebase Console](https://console.firebase.google.com/), login if needed, and tap on the `Add project`.
2. Select a project name and tap `Continue` to proceed.
3. On the next page, select whether you want to use Firebase Analytics or not and click the `Continue`/`Create project` to proceed.
4. Select a Firebase analytics account if you are using the Firebase Analytics and tap on `Create project`. 

After a couple of seconds, your project will be ready, and you'll be redirected to the project console.  
Your next step will be to create a Firestore database: 

1. Go to the `Database` tab on the left bar and click the `Create database` button under the `Cloud Firestore`. 
2. Select `Start in test mode` to create a database with no security rules for now and tap `Next`.
3. Select your database location and click `Done`.

After a while, your database will be created, and you will see the database console page.

## Firebase configuration

When your Firestore database is up, you need to add a Web application to your Firebase project,
to be able to connect your web application with the Firestore database: 

1. In the [Firebase Console](https://console.firebase.google.com/), open your project and go to
 the project setting page (tap on the setting gear icon near the `Project Overview` on top of the 
 left panel and select `Project settings`).
2. Scroll down and find `There are no apps in your project` text,
 and tap on the `</>` icon to add a new Web application to your Firebase project
3. Choose the app nickname and check `Also set up Firebase Hosting for this app`.
4. Select from the dropdown menu, or create a new site for your application and tap the `Register app` to proceed.
5. If you are going to use the Firestore database from the same Firebase project, you are deploying the
 application to - skip the `Configure Firebase SDK` step. If you want to use Firestore Database
 from another Firebase project or you are going to run the application on the localhost,
 see [Firebase SDK configuration](https://github.com/software-platform/monorepo/blob/firebase_deployment_instructions/docs/10_firebase_sdk_configuration.md) document.
6. Tap on the `Next` button and follow instructions to install the Firebase CLI.
7. Skip the `Deploy to Firebase Hosting` and tap on the `Continue to console` to finish configuring your Firebase Web application.
 The deployment process described more detailed in
  [Building and deploying the application to the Firebase Hosting](#Building-and-deploying-the-application-to-the-Firebase-Hosting) section.
 
If you've skipped the fifth step, and you want to run your flutter application locally:

1. Select recently created application in the `Your apps` section in Firebase project settings.
2. Select the `Config` under the `Firebase SDK snippet`.
3. Replace the current `firebaseConfig` variable in `metrics/web/index.html` with the generated code.

 
Finally, you have a configured flutter application that works with your Firebase instance.
It's time to deploy your flutter application to the Firebase Hosting!
 
## Building and deploying the application to the Firebase Hosting

### Preparing your environment 
Before deploying metrics application, make sure you have the correct flutter version installed,
 by running the `flutter --version` command. You should have `v1.15.3` installed. 

To switch the flutter to the required version, you need to run the `flutter version 1.15.3` command.

Also, you have to enable flutter web support by running the `flutter config --enable-web` command.

### Building and deploying Flutter application
 
1. Open the terminal and navigate to the metrics project folder.
2. Run `firebase login` command and follow the instructions to log in to the Firebase CLI with your Google account.
 Use the same account that you used to create your Firebase project (or the one that has access to it).
3. After you have logged in, run the `firebase use --add` command, and select the project id of the project, created in previous steps.
4. Give an alias to your project.
5. Run the `flutter build web` command from the root of the metrics project to builds the release version of the application.
 Recommended that you add `--dart-define=FLUTTER_WEB_USE_SKIA=true` parameter to build the application with the `SKIA` renderer.
4. Run the `firebase deploy --only hosting` command to deploy an application to the Firebase Hosting.

After the deployment process finished, your application will be accessible using the `Hosting URL`, printed to console.

## Creating test data for deployed application

Once you've deployed the metrics application to the Firebase Hosting, you can create a sample data to test the application.  
The application reads data from 2 firestore collections: `projects` and `build`. To create a sample data follow the next steps: 

1. Deploying seedData Firestore function: 
    1. Go to the `metrics/firebase/index.js` file and comment this line of code: `return resp.status(200).send('done');`.
    2. Open console, navigate to `metrics` directory and run `firebase deploy --only functions`
     command to deploy this cloud function.
    3. Once the function deployment finished, the URL will be printed to the console.
     You can trigger this function to create builds from the project, using this URL.  
     This HTTP function has such query parameters: 
        - buildsCount (required) - number of builds to be generated.
        - projectId (required) - the project identifier for which builds will be generated.
        - startDate (optional) - builds will be generated with 'startedAt'
         property in the range from startDate to startDate - 7 days. Defaults to the current date.
        - delay (optional) - is the delay in milliseconds between adding builds to the project.

2. Creating projects in Firestore Database:
    1. Go to [Firebase Console](https://console.firebase.google.com/), and select the project, created in previous steps.
    2. Go to the database section on the left panel and tap on the `Start collection` button.
    3. Add collection with `projects` identifier and tap `Next`. 
    4. In the document creation window tap on the `Auto-ID` button or enter the project identifier you want.
    5. Add a field named `name` with the `String` type and the name for your project as a value.

# Dependencies

> What is the project blocked on?

This project has no dependencies.

> What will be impacted by the project?

Nothing will be impacted by this project.

# Testing

> How will the project be tested?

This project will be tested manually by opening an application using the obtained link.

# Alternatives Considered

> Summarize alternative designs (pros & cons)

N/A

# Timeline

> Document milestones and deadlines.

DONE:

  - Deploy Metrics application to the Firebase Hosting.
  
# Results

> What was the outcome of the project?

The Metrics application and the Cloud function for creating test data deployed and available on the link.
