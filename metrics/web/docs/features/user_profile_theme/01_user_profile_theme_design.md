# User profile theme design

## Firestore

### Document structure

We want to add a `user_profiles` collection to the Firestore database. This collection will contain the documents of the user profiles with the following structure: 

```json
firebaseAuthUserId : {
  selectedTheme: String
}
``` 


So, the identifier of the document will be the unique identifier of the Firebase user, and the document will contain the data about the user's selected theme. We will store the selected theme as a `String` representation of the dart `enum` value.

### Firestore security rules

Once we have a new collection, we have to add security rules for this collection. So, we should set the following constraints to the `user_profiles` collection: 


- Access-related rules: 
  - not authenticated users **cannot** read, create, update, and delete any document in this collection;
  - authenticated users have the following permissions: 
    - **can** create, update, and read the user profile if **the Firebase Auth identifier of the user equals to document identifier**. In other words, the user can create, update, and read their user profile;
    - **cannot** create, update, delete or read the documents with the identifier different from their Firebase Auth identifier;
  - authenticated and not authenticated users **cannot** delete any user profiles;

- Data validation related rules: 
  - the `selectedTheme` field should be the valid `String` representation of the dart `enum` or `null`;
  - the `user_profile` document should not contain any additional field except `selectedTheme`;


## Metrics application

### Domain layer

In the application domain layer, we should add an ability to create, update, and read the user profile. For this purpose, we should: 

1. Create an `UserProfile` entity.
2. Add the `createUserProfile`, `userProfileStream`, and `updateUserProfile` methods to the `UserRepository`.
3. Implement the `ReceiveUserProfileUpdates`, `CreateUserProfileUseCase`, and `UpdateUserProfileUseCase` classes.
4. Add the needed `parameter` classes.


So, the domain layer should look like this: 

![Domain layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/user_profile_theme/diagrams/user_profile_theme_domain_class.puml)

### Data layer

The `FirestoreUserRepository` of the data layer should implement new methods from the `UserRepository` interface. To do that, we should create an `UserProfileData` class implementing the `DataModel` class and containing the `fromJson` factory and `toJson` method.

The following class diagram represents the classes of the data layer required for this feature: 

![Data layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/user_profile_theme/diagrams/user_profile_theme_data_class.puml)

### Presentation layer

Once we've created a `domain` and `data` layers, it's time to create a `presentation` layer. This layer contains the `AuthNotifier` - the class that manages the authentication state and will load/save the changes in the user profile. Also, the `presentation` layer contains the `ThemeNotifier` responsible for managing the theme state and will provide information about the currently selected theme type. To introduce this feature, we should follow the next steps: 

1. Create a method in the `AuthNotifier` to be able to update the user profile.
2. Create a `userProfileSavingErrorMessage` getter that will return the error message that occurred during saving the user profile.
3. Integrate created use cases to the `AuthNotifier`. 
4. Create a `UserProfileModel` class for notifiers communication.
5. Connect the `AuthNotifier` with the `ThemeNotifier` to be able to update the currently selected theme type once it is updated in the database or by the user.


The structure of the presentation layer shown in the following diagram: 

![Presentation layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/user_profile_theme/diagrams/user_profile_theme_presentation_class.puml)

Also, we should create a user profile record once we receive a new user. The following sequence diagram displays the logic of logging in the user.

![User creation diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/user_profile_theme/diagrams/user_profile_creation_sequence.puml)

So, the `isLoggedIn` value of the `AuthNotifier` should depend on the `UserProfile` now, but not on the `FirebaseUser`. In other words, we can say that the user is logged in only when the `UserProfile` is not null in the `AuthNotifier`.

Let's consider the mechanism of changing the selected theme. To change the selected theme, the UI should trigger the `changeTheme` method from the `ThemeNotifier` once the user toggles the `dark`/`light` theme. Also, the `AuthNotifier` should call the `changeTheme` method once the user selected theme changed in the database. The `ThemeNotifier`, in its turn, should call the `updateUserProfile` method from the `AuthNotifier` to update the selected theme in the database.

The following sequence diagram shows the process of changing the application theme: 

![Theme change diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/user_profile_theme/diagrams/user_profile_theme_presentation_sequence.puml)

As we can see in the sequence diagram above, the `ThemeNotifier` should, in some way, communicate with the `AuthNotifier` and vise versa. Let's consider the way of communication between these two provides. 

To make the `AuthNotifier` and `ThemeNotifier` communicate, we should: 

1. Create instances of these notifiers in the `initState` of the `InjectionContainer`.
2. Add listeners to the `AuthNotifier` and the `ThemeNotifier` to make the `AuthNotifier` trigger the `ThemeNotifier` once it changes and vise versa. 
3. Create a `ChangeNotifierProvider.value` provider for each of these notifiers to make them available across the project. 

So, after we've finished with these steps, the `AuthNotifier` will notify the `ThemeNotifier` about the theme type changes in the persistent store, and the `ThemeNotifier` will notify the `AuthNotifier` that the user changed the theme type on the UI.
