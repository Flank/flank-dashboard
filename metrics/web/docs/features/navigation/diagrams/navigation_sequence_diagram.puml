
@startuml routing_sequence_diagram

    actor Bob

    participant Browser
    participant RouteInformationProvider

    box Parsing route information
        participant AppRouteInformationParser
        participant RouteConfigurationFactory
    endbox

    box Configuring pages
        participant AppRouterDelegate
        participant NavigationNotifier
        participant AppRoutePageFactory
    endbox 

    participant Application

    alt Initial open page
        Bob -> Browser : Initial page opening
        activate Browser
    else Change the URL
        Bob -> Browser : Navigates back and forth through history
    end

    Browser -> RouteInformationProvider : Notifies about the URL changes
    activate RouteInformationProvider

    RouteInformationProvider -> AppRouteInformationParser : parseRouteInformation(RouteInformation routeInformation)
    activate AppRouteInformationParser

    AppRouteInformationParser -> RouteConfigurationFactory : create(Uri uri)
    activate RouteConfigurationFactory

    RouteConfigurationFactory -> AppRouteInformationParser : RouteConfiguration

    alt Initial open page
       AppRouteInformationParser -> AppRouterDelegate : setInitialRoutePath(routeConfiguration)
        activate AppRouterDelegate

        AppRouterDelegate -> NavigationNotifier : setInitialRoutePath(routeConfiguration)
        activate NavigationNotifier
    else Change the URL
        AppRouteInformationParser -> AppRouterDelegate : setNewRoutePath(routeConfiguration)

        AppRouterDelegate -> NavigationNotifier : setNewRoutePath(routeConfiguration)
    end

    NavigationNotifier -> AppRoutePageFactory : create(RouteConfiguration configuration)
    activate AppRoutePageFactory

    AppRoutePageFactory -> NavigationNotifier : actual page

    NavigationNotifier -> AppRouterDelegate: notifyListeners()

    AppRouterDelegate -> Application : shows the actual page
    activate Application

    Application -> NavigationNotifier : pushNamed('cool page')
    deactivate Application

    NavigationNotifier -> AppRoutePageFactory : create(RouteConfiguration configuration)

    AppRoutePageFactory -> NavigationNotifier : Cool Page
    deactivate AppRoutePageFactory

    NavigationNotifier -> AppRouterDelegate : notifyListeners()
    deactivate NavigationNotifier

    AppRouterDelegate -> AppRouteInformationParser : restoreRouteInformation(RouteConfiguration routeConfiguration)
    deactivate AppRouterDelegate

    AppRouteInformationParser -> RouteInformationProvider : routerReportsNewRouteInformation(RouteInformation routeInformation)
    deactivate AppRouteInformationParser

    RouteInformationProvider -> Browser : notify to change the URL
    deactivate RouteInformationProvider

    Browser -> Bob : new page with updated URL
@enduml
