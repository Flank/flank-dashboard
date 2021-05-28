# Project metrics definitions

## Build Status Metric
#### Description 
A build status metric is the result of the latest build. It can be successful, failed, unknown, or in-progress. If there are no builds for this project, the build status metrics can be `null`.
* A successful build result indicates the success of all necessary checks, such as tests, code style analysis, builds, 
and others.   
* A failed build result indicates the CI building job failed (some tests failed, compile-time error, CI-side issues, etc.)
* An unknown build result indicates that the last build has a build status, different from successful or failed.
* An in-progress build result indicates that the last build is not finished yet.
* A `null` build status indicates that there are no builds.
#### Source
The information about the build result comes from the CI system with the other information about other builds.  
#### Date ranges
The build status includes the status of the latest build.
#### Appearance
* A successful build result is a checkmark on a green background. 
* A failed build result is a cross on a red background.
* An in-progress build result is an animated spinner.
* An unknown or `null` build result is a dash on a gray background.

![Build Statuses (Dark theme)](./images/build_statuses.png?raw=true)    
Build Statuses (Dark theme) - Positive, Negative, In-progress, Unknown.    

![Build Statuses (Light theme)](./images/build_statuses_light.png?raw=true)    
Build Statuses (Light theme) - Positive, Negative, In-progress, Unknown.    

## Build Results Metric
#### Description
A build results metric includes the build results and duration of the latest builds. Same as build statuses, build results can be successful, failed, unknown, or in-progress.
#### Source
The information about build results comes from the CI system that performs these builds.
#### Date ranges
The build results metric includes the results of the last 30 builds.
#### Appearance
The build results metric appears as a bar graph with a date range that includes dates of the first and last builds the build result metric includes. Each bar stands for one build result.
The height of each bar stands for the build duration. The height of each bar is relative. That means that two bars in different projects with the same height may have a different duration.
* If the build result is successful, the app uses a green bar.
* If the build result is failed, the app uses a red bar.
* If the build result is unknown, the app uses a grey bar.
* If the build result is in-progress, the app uses a dashed animated bar. 
* If there are not enough builds to fill in, all the 30 bars the app fills the rest with the grey dashes at the bottom of a graph.

![Build Results (Dark theme)](./images/build_results_bar.png?raw=true)    
Build Results (Dark theme).    

![Build Results (Light theme)](./images/build_results_bar_light.png?raw=true)    
Build Results (Light theme).

## Performance Metric
#### Description
A performance metric is an average build duration of successful builds, excluding the queue time. 
#### Source
The information about each build duration comes from the CI system and includes the duration of all performed checks. 
#### Date ranges
A performance metric displays the performance by the last 7 days, including the current day (today and 6 days before).
A sparkline performance graph displays an average daily build duration of the last 7 days, including the current day (today and 6 days before).
#### Appearance
A performance metric is a label with a performance sparkline graph below it. If there are no builds for the last 7 days, the grey dash is displayed instead of a sparkline graph with a label.

![Performance Metric (Dark theme)](./images/performance_graph.png?raw=true)    
Performance Metric (Dark theme).    

![Performance Metric (Light theme)](./images/performance_graph_light.png?raw=true)      
Performance Metric (Light theme).  

![Empty Performance Metric (Dark theme)](./images/placeholder.png?raw=true)    
Performance Metric with no builds (Dark theme).    

![Empty Performance Metric (Light theme)](./images/placeholder_light.png?raw=true)      
Performance Metric with no builds (Light theme).    

## Builds Metric
#### Description
A builds metric is a count of performed builds of the project per week. 
#### Source
The information about the number of builds comes from the CI system.
#### Date ranges
A builds metric includes the number of builds by the last 7 days, including the current day (today and 6 days before).    
#### Appearance
A builds metric is a label containing the number of builds. If there are no builds for the last 7 days, the grey dash is displayed.

![Builds (Dark theme)](./images/builds.png?raw=true)    
Builds (Dark theme).      

![Builds (Light theme)](./images/builds_light.png?raw=true)   
Builds (Light theme).   

![Empty Builds (Dark theme)](./images/placeholder.png?raw=true)    
Builds metric with no builds (Dark theme).      

![Empty Builds (Light theme)](./images/placeholder_light.png?raw=true)   
Builds metric with no builds (Light theme).    
                    
## Stability Metric
#### Description
A Stability metric is a ratio of successful builds to finished builds for the last 30 builds. So, stability is equal to `S/T`, where: 
* `S` is the number of successful builds of the last 30 builds.
* `T` is the number of the finished builds for the last 30 builds. A build is considered finished if it has a non in-progress build status.
#### Source
A stability metric is calculated out of the last 30 builds.
#### Date ranges
A stability metric includes the stability calculated from the last 30 builds.
#### Appearance
Depending on its value, stability appears differently:
* A positive stability has the value >= 80%, and the app applies green colors to it.
* A neutral stability has the value < 80% and >= 51%, and the app applies yellow colors to it.
* A negative stability has the value < 51%, and the app applies red colors to it.
* In all other cases (there are no builds at all, or no builds report the build status), the stability is inactive, and the app displays it as a dash mark on a grey background.

![Stability (Dark theme)](./images/percentage.png?raw=true)    
Stability (Dark theme) - Positive, Neutral, Negative, Inactive.

![Stability (Light theme)](./images/percentage_light.png?raw=true)   
Stability (Light theme) - Positive, Neutral, Negative, Inactive. 

## Coverage Metric
#### Description
Coverage metrics displays a project code coverage of the tests, measured in percent. Depending on the configuration it could be: line coverage, branch, function, etc.
#### Source
The CI system generates the coverage artifact. After that the CI integrations component processes this artifact and transfers the coverage to the database. 
See [coverage converter design](https://github.com/Flank/flank-dashboard/blob/master/metrics/coverage_converter/docs/01_coverage_converter_design.md).
#### Date ranges
A coverage metric displays the coverage of the last successful build.
#### Appearance
Depending on its value, coverage appears differently:
* A positive coverage has the value >= 80%, and the app applies green colors to it.
* A neutral coverage has the value >= 80% < 80% and >= 51%, and the app applies yellow colors to it.
* A negative coverage has the value >= 80%, and the app applies red colors to it.
* In all other cases (there are no successful builds or no builds at all), the coverage is inactive, and the app displays the stability as a dash mark on a grey background.

![Coverage (Dark theme)](./images/percentage.png?raw=true)    
Coverage (Dark theme) - Positive, Neutral, Negative, Inactive. 

![Coverage (Light theme)](./images/percentage_light.png?raw=true)   
Coverage (Light theme) - Positive, Neutral, Negative, Inactive. 
