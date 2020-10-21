# Project metrics definitions

## Build Result
A build result is the result of the latest build. It can be successful, failed, or unknown.
The information about the build result comes from the CI system. 
* A successful build result is displayed as a checkmark on a [light] green background. A successful build result 
indicates the success of all necessary checks, such as tests, code style analysis, builds, etc.   
![Successful Build Result (Dark theme)](images/successful_build_result.png)    
Successful Build Result (Dark theme)    
![Successful Build Result (Light theme)](images/successful_build_result_light.png)    
Successful Build Result (Light theme)    

* A failed build result is displayed as a cross on a [light] red background. A failed build result indicates a failure 
of some necessary checks.
![Failed Build Result (Dark theme)](images/failed_build_result.png)    
Failed Build Result (Dark theme)    
![Failed Build Result (Light theme)](images/failed_build_result_light.png)    
Failed Build Result (Light theme)    

* An unknown build result is displayed as a dash on a gray background. An unknown build status indicates an absence of 
builds to display a build result.
![Unknown Build Result (Dark theme)](images/unknown_build_result.png)    
Unknown Build Result (Dark theme)    
![Unknown Build Result (Light theme)](images/unknown_build_result_light.png)    
Unknown Build Result (Light theme)

## Performance
Performance is as an average build duration of successful builds excluding the queue time.
It is displayed as a label, with a performance sparkline graph below it.
A performance sparkline graph includes maximum 6 points and each points stands for an average performance for 
the last 7 days.

## Builds
Count of builds per week per project.

## Stability
Percentage of successful builds to total builds per week. For example, if 6 our of 10 builds are successful metric value is 60%. 

## Coverage
Shows the percentage of lines of code executed while running tests to total lines of code.

**branch coverage** is the selected metric for code coverage. Web projects report a summary JSON `coverage/coverage-summary.json` from [istanbul](https://istanbul.js.org/docs/advanced/alternative-reporters/#json-summary)


