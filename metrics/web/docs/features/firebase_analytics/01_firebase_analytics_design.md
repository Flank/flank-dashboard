# Firebase Analytics design

## Metrics application

### Domain layer

In the application domain layer, we should add an ability to log user activities. For this purpose, we should: 

1. Add the `logLogin` and `logPageView` methods to the `FirebaseAnalyticsRepository`.
2. Implement the `LogLoginUseCase` and `LogPageViewUseCase` classes.

So, the domain layer should look like this:

![Domain layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/firebase_analytics_design/metrics/web/docs/features/firebase_analytics/diagrams/firebase_analytics_domain_class.puml)


### Data layer

The `FirebaseAnalyticsRepository` of the data layer should implement new methods from the `AnalyticsRepository` interface.

The following class diagram represents the classes of the data layer required for this feature: 

![Data layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/firebase_analytics_design/metrics/web/docs/features/firebase_analytics/diagrams/firebase_analytics_data_class.puml)

### Presentation layer

Once we've created a `domain` and `data` layers, it's time to create a `presentation` layer. This layer contains the `AuthNotifier` - the class that manages the authentication state and will log the user login. Also, the `presentation` layer contains the `FirebaseAnalyticsObserver` responsible for logging the page when the user changes the current page. To introduce this feature, we should follow the next steps: 

1. Create a method in the `AuthNotifier` to be able to log the user login.
2. Integrate created use case to the `AuthNotifier`. 
3. Create a `FirebaseAnalyticsObserver` to be able to log the page changes.
4. Integrate created use case to the `FirebaseAnalyticsObserver`. 


The structure of the presentation layer shown in the following diagram: 

![Presentation layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/firebase_analytics_design/metrics/web/docs/features/firebase_analytics/diagrams/firebas_analytics_presentation.puml)