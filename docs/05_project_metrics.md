# Project metrics definitions

## Build Result Metric
#### Description 
A build result is the result of the latest build. It can be successful, failed, or unknown.
* A successful build result indicates the success of all necessary checks, such as tests, code style analysis, builds, 
and others.   
* A failed build result indicates a failure of some necessary checks.
* An unknown build status indicates an absence of builds to display a build result.
#### Source
The information about the build result comes from the CI system with the other information about other builds.  
#### Date ranges
The build status includes the status of the latest build.
#### Appearance
* A successful build result is displayed as a checkmark on a green background. 
* A failed build result is displayed as a cross on a red background. 
* An unknown build result is displayed as a dash on a gray background.   

![Build Results (Dark theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/build_results.png?raw=true)    
Build Results (Dark theme) - Positive, Negative, Unknown.    

![Build Results (Light theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/build_results_light.png?raw=true)    
Build Results (Light theme) - Positive, Negative, Unknown.    

## Performance Metric
#### Description
A performance metric is an average build duration of successful builds excluding the queue time. 
#### Source
The information about each build duration comes from the CI system and includes the duration of all performed checks. 
#### Date ranges
A performance metric displays the performance by the last 6 days, including the current day.
A sparkline performance graph displays an average daily performance of the last 6 days, including the current day.
#### Appearance
A performance metric is displayed as a label, with a performance sparkline graph below it.

![Performance Metric (Dark theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/performance_graph.png?raw=true)    
Performance Metric (Dark theme).    

![Performance Metric (Light theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/performance_graph_light.png?raw=true)      
Performance Metric (Light theme).    

## Builds Metric
#### Description
A builds metric is a count of performed builds per week per project. 
#### Source
The information about the number of builds comes from the CI.
#### Date ranges
A builds metric includes the builds number per last 6 days including the current day.    
#### Appearance
A builds metric is displayed as a label containing the number of builds.

![Builds Number (Dark theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/builds.png?raw=true)    
Builds Number (Dark theme).      

![Builds Number (Light theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/builds_light.png?raw=true)   
Builds Number (Light theme).    
                    
## Stability Metric
#### Description
A Stability metric is a ratio of successful builds to total builds per week, measured in percent. 
For example, if 6 out of 10 builds are successful metric value is 60%. 
#### Source
The information about the stability comes from the CI system.
#### Date ranges
A stability metric includes the stability of the last 6 days including the current day.
#### Appearance
Depending on its value, stability appears differently:
* If the stability is >= 80%, it is considered positive and green colors are used.
* If the stability is < 80% and >= 51%, it is considered neutral and yellow colors are used.
* If the stability is < 51%, it is considered negative and red colors are used.
* If the stability is not specified, it is considered inactive and the stability is displayed as a dash mark on a grey background.

![Stability (Dark theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/percentage.png?raw=true)    
Stability (Dark theme) - Positive, Neutral, Negative, Inactive.

![Stability (Light theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/percentage_light.png?raw=true)   
Stability (Light theme) - Positive, Neutral, Negative, Inactive. 

## Coverage
#### Description
Coverage metric is a ratio of lines of code executed while running tests to total lines of code, measured in percent.
#### Source
The information about the coverage comes from the coverage artifact that is created by the CI system and converted by 
the CI integrations module.
#### Date ranges
A coverage metric includes the stability of the last 6 days including the current day.
#### Appearance
Depending on its value, coverage appears differently:
* If the coverage is >= 80%, it is considered as positive and green colors are used.
* If the coverage is < 80% and >= 51%, it is considered as neutral and yellow colors are used.
* If the coverage is < 51%, it is considered as negative and red colors are used.
* If the coverage is not specified, it is considered as inactive and the stability is displayed as a dash mark on a grey background.

![Coverage (Dark theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/percentage.png?raw=true)    
Coverage (Dark theme) - Positive, Neutral, Negative, Inactive. 

![Coverage (Light theme)](https://github.com/platform-platform/monorepo/blob/update_project_metrics_document/docs/images/percentage_light.png?raw=true)   
Coverage (Light theme) - Positive, Neutral, Negative, Inactive. 
