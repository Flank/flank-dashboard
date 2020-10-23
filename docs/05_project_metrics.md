# Project metrics definitions

## Build Status Metric
#### Description 
A build status metric is the result of the latest build. It can be successful, failed, or unknown.
* A successful build result indicates the success of all necessary checks, such as tests, code style analysis, builds, 
and others.   
* In any other cases the build result is unknown.
* An unknown build status indicates an absence of builds to display a build result.
#### Source
The information about the build result comes from the CI system with the other information about other builds.  
#### Date ranges
The build status includes the status of the latest build.
#### Appearance
* A successful build result is a checkmark on a green background. 
* A failed build result is a cross on a red background. 
* An unknown build result is a dash on a gray background.   

![Build Statuses (Dark theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/build_statuses.png?raw=true)    
Build Statuses (Dark theme) - Positive, Negative, Unknown.    

![Build Statuses (Light theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/build_statuses_light.png?raw=true)    
Build Statuses (Light theme) - Positive, Negative, Unknown.    

## Build Results Metric
#### Description
A build results metric includes the build results and duration of the latest builds. Same as build statuses, build results can be successful, failed, unknown.
#### Source
The information about build results comes from the CI system that performs these builds.
#### Date ranges
The build results metric includes the results of the last 20 builds
#### Appearance
The build results metric appears as a bar graph. Each bar stands for one build result. The height of each bar stands for the build duration.
* If the build result is successful the app uses a green bar.
* If the build result is failed the app uses a red bar.
* If the build result is unknown the app uses a grey dash at the bottom of a bar.

![Build Results (Dark theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/build_results_bar.png?raw=true)    
Build Results (Dark theme).    

![Build Results (Light theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/build_results_bar_light.png?raw=true)    
Build Results (Light theme).


## Performance Metric
#### Description
A performance metric is an average build duration of successful builds, excluding the queue time. 
#### Source
The information about each build duration comes from the CI system and includes the duration of all performed checks. 
#### Date ranges
A performance metric displays the performance by the last 7 days, including the current day (today and 6 days before).
A sparkline performance graph displays an average daily performance of the last 7 days, including the current day (today and 6 days before).
#### Appearance
A performance metric is a label, with a performance sparkline graph below it.

![Performance Metric (Dark theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/performance_graph.png?raw=true)    
Performance Metric (Dark theme).    

![Performance Metric (Light theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/performance_graph_light.png?raw=true)      
Performance Metric (Light theme).    

## Builds Metric
#### Description
A builds metric is a count of performed builds of the project per week. 
#### Source
The information about the number of builds comes from the CI system.
#### Date ranges
A builds metric includes the builds number by the last 7 days including the current day (today and 6 days before).    
#### Appearance
A builds metric is a label containing the number of builds.

![Builds Number (Dark theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/builds.png?raw=true)    
Builds Number (Dark theme).      

![Builds Number (Light theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/builds_light.png?raw=true)   
Builds Number (Light theme).    
                    
## Stability Metric
#### Description
A Stability metric is a ratio of successful builds of the last 14 builds. 
#### Source
The information about stability is calculated based on the builds (and it's statuses) ran on the CI
#### Date ranges
A stability metric includes the stability of the last 14 builds.
#### Appearance
Depending on its value, stability appears differently:
* A positive stability has the value >= 80% and the app applies green colors to it.
* A neutral stability has the value < 80% and >= 51%, and the app applies yellow colors to it.
* A negative stability has the value < 51% and the app applies red colors to it.
* In all other cases, the stability is inactive and the app displays it as a dash mark on a grey background.

![Stability (Dark theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/percentage.png?raw=true)    
Stability (Dark theme) - Positive, Neutral, Negative, Inactive.

![Stability (Light theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/percentage_light.png?raw=true)   
Stability (Light theme) - Positive, Neutral, Negative, Inactive. 

## Coverage Metric
#### Description
Coverage metric is a ratio of lines of code executed while running tests to total lines of code, measured in percent.
#### Source
The CI system generates the coverage artifact. After that the CI integrations component processes this artifact and transfers the coverage to the database. 
See [coverage converter design](https://github.com/platform-platform/monorepo/blob/master/metrics/coverage_converter/docs/01_coverage_converter_design.md).
#### Date ranges
A coverage metric displays the coverage of the last successful build.
#### Appearance
Depending on its value, coverage appears differently:
* A positive coverage has the value >= 80% and the app applies green colors to it.
* A neutral coverage has the value >= 80% < 80% and >= 51% and the app applies yellow colors to it.
* A negative coverage has the value >= 80% and the app applies red colors to it.
* In all other cases the coverage is inactive and the app displays the stability as a dash mark on a grey background.

![Coverage (Dark theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/percentage.png?raw=true)    
Coverage (Dark theme) - Positive, Neutral, Negative, Inactive. 

![Coverage (Light theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/percentage_light.png?raw=true)   
Coverage (Light theme) - Positive, Neutral, Negative, Inactive. 
