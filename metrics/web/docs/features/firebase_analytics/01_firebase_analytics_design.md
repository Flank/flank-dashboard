# Firebase Analytics design

## Metrics application

### Domain layer

In the application domain layer, we should add an ability to log user activities. For this purpose, we should: 

1. Add the `logLogin` and `logPageView` methods to the `AnalyticsRepository`.
2. Implement the `LogLoginUseCase` and `LogPageViewUseCase` classes.
3. Add the needed parameter classes.

Also, to be sure that the logged page exists and avoid passing the invalid data to the `logPageView` method, the domain layer contains the `PageName` class that implements an `Enum` interface from the `metrics core` package. The `PageName` class has a private constructor that will make us safe that someone will instantiate a new instance with a wrong page name somewhere.

So, the domain layer should look like this:

![Domain layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/firebase_analytics/diagrams/firebase_analytics_domain_class.puml)

### Data layer

The `FirebaseAnalyticsRepository` of the data layer should implement methods from the `AnalyticsRepository` interface.

The following class diagram represents the classes of the data layer required for this feature: 

![Data layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/firebase_analytics/diagrams/firebase_analytics_data_class.puml)

### Presentation layer

Once we've created a `domain` and `data` layers, it's time to create a `presentation` layer. This layer contains the `AnalyticsNotifier` - the class used to log analytics data such as user login or page change. Also, the `presentation` layer contains the `FirebaseAnalyticsObserver` responsible for providing a callback when the user changes the current page. To introduce this feature, we should follow the next steps: 

1. Create methods in the `AnalyticsNotifier` to be able to log the user logins and page changes.
2. Integrate the `LogLoginUseCase` and `LogPageViewUseCase` to the `AnalyticsNotifier`.
3. Connect the `AnalyticsNotifier` with the `AuthNotifier` to be able to log the user logins.
4. Create a `FirebaseAnalyticsObserver` to be able to track the page changes.
5. Integrate the `AnalyticsNotifier` to the `FirebaseAnalyticsObserver` to be able to log the page changes.

The structure of the presentation layer shown in the following diagram: 

![Presentation layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/firebase_analytics/diagrams/firebase_analytics_presentation.puml)

The following sequence diagram displays the logic of logging the user logins.

![Log login sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/firebase_analytics/diagrams/firebase_analytics_log_login_sequence.puml)

The following sequence diagram displays the logic of logging the page changes.

![Log page view sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/firebase_analytics/diagrams/firebase_analytics_log_page_view_sequence.puml)
