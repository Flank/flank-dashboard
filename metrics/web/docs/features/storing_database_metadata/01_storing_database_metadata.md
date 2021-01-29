# Storing Database Metadata
> Summary of the proposed change

Store the database version to simplify the Metrics Application update process.

# Motivation
> What problem is this project solving?

Simplifies the process of updating the Metrics Application with the database structure. 

# Goals
> Identify success metrics and measurable goals.

This document follows the next goals: 

- Describe the place of storing the database metadata.
- Describe the mechanism of blocking the application during updating the database.

# Non-Goals
> Identify what's not in scope.

This document does not include any information on how to update the application/database. Also, the loading of the current database version to the Metrics Application is out of scope. 

# Design

> Explain and diagram the technical design
>
> Identify risks and edge cases

To detect the database updates from the Metrics Web Application, we should add the `metadata` collection to the Firestore database to store database metadata ё, and have a current version of the application in the Metrics Web Application.

Let's review the way of storing the database metadata: 

## Database metadata
> Explain the way of storing and loading the database metadata in the Firestore database.

### Firestore 
> Explain the way of storing the database metadata in the Firestore database - database structure and rules.

To store the database version and make it easily accessible, we need to add to the `metadata` collection with the `metadata` document. This document will contain the `databaseVersion` field of `String` and `isUpdating` field of `bool`. 

So, the database structure should look like the following: 

> - projects
> - ...
> - metadata
>   - metadata
>       - databaseVersion: String
>       - isUpdating : bool


The `metadata` collection should have the following security rules: 

- No one can write (update, delete, create) documents in this collection.
- Anybody can read the documents from this collection. 

## Application Version
> Explain the way of storing the application version and providing it to the Metrics Web Application.

To be able to detect if the current application version is compatible with the database, we should have the current application version in the `Metrics Web Application`. Since this value is common for database and metrics applications we should make it easily accessible in any application like `CI Integrations`, `Metrics CLI`, or `Metrics Web`. To do so, we can store this version in the `version` file under the `metrics` package of our repository and then we can get the contents of this file and pass it as an environment variable to any of our applications during building process.

Let's consider a Unix script example of getting the application version from the file and passing it to the `Metrics Web Application` as an environment variable: 

Assume we run this script inside the `metrics/web` package: 

```bash
VERSION=$(cat ../version)

flutter build web --release --dart-define=APP_VERSION=$VERSION
```

So,we can use the following line of code to get the Metrics Application version: 

```dart
const appVersion = String.fromEnvironment('APP_VERSION');
```

## Making things work

Once we have a database version in the Firestore database and an application version, we should block the application if the application version does not equal to the database version. In this case, we should redirect user to the `Update application` page that will contain an information that the current application version is not compatible with the current database version and the user should contact an administrator to resolve this conflict. Also, it the database is currently updating, we should redirect user to the `Application update in progress` page that will provide an information that the application is currently unavailable due to update in progress. 


# Dependencies
> What will be impacted by the project?

This project will impact the build process of a Metrics Web Application

# Results

> What was the outcome of the project?

This document described the place of storing the database metadata and the mechanism of of blocking the Metrics Web Application in case when the current database version is not compatible with the application version.
