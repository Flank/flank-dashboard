@startuml
package widgets {
    class InjectionContainer {}

    class MaterialApp {}
}

package common.presentation.navigation {
        package path_configuration{
            class RouteConfiguration{
               + routeEnum : AppRouteEnum
               + name : String
               + path : String
               + authorizationRequired : bool
               + nestedRouteInformationFactory : RouteConfigurationFactory
            }
           class AppRouteEnum{}
           class RouteConfigurationFactory{
               + RouteConfiguration create()
               - RouteConfiguration _handleNested()
           }
        }
        class AppRouteInformationParser{
            Future<RouteConfiguration> parseRouteInformation()
            RouteInformation restoreRouteInformation()
        }
        class AppRouterDelegate{
            + navigationNotifier : NavigationNotifier
            + navigatorKey : GlobalKey<NavigatorState>
            + currentConfiguration : RouteConfiguration
            + Future<void> setInitialRoutePath(RouteConfiguration routeConfiguration)
            + Future<void> setNewRoutePath(RouteConfiguration routeConfiguration)
        }
        class NavigationNotifier{
            + pages : List<Page> 
            + currentConfiguration : RouteConfiguration
            - _appRoutePageFactory : AppRoutePageFactory
            - _routeConfigurationFactory : RouteConfigurationFactory
            - _isUserLoggedIn : bool
            + void handleUserStateUpdates(bool isLoggedIn)
            + void addNewPage(Page page)
            + void popNamed(String path)
            + void pushReplacement(Page page)
            + void didPop(Page page)
            + void pushNamed(String path)
            + void pushReplacementNamed(String path)
            + void pushAndRemoveWhere(String path, bool Function(Page) test)
            + void setInitialRoutePath(RouteConfiguration routeConfiguration)
            + void setNewRoutePath(RouteConfiguration routeConfiguration)
        }
        class AppRoutePageFactory{
            + AppRoutePage<T> create<T>()
        }
      
        class AppRoutePage{
            + builder : WidgetBuilder
            + maintainState : bool
            + fullScreenDialog : bool
            + Route<T> createRoute()
        } 
}

InjectionContainer --> MaterialApp : provides NavigationNotifier
InjectionContainer --> AppRouterDelegate : provides NavigationNotifier
MaterialApp --> AppRouteInformationParser :uses
MaterialApp --> AppRouterDelegate : uses
AppRouteInformationParser --> RouteConfiguration : provides
AppRouteInformationParser --> RouteConfigurationFactory : uses
RouteConfiguration --> AppRouteEnum : uses
RouteConfiguration --> RouteConfigurationFactory : uses
AppRouterDelegate --> NavigationNotifier : uses
NavigationNotifier --> RouteConfigurationFactory : uses
NavigationNotifier --> RouteConfiguration : uses
NavigationNotifier --> AppRoutePageFactory : uses
AppRoutePageFactory --> AppRoutePage : uses
@enduml
