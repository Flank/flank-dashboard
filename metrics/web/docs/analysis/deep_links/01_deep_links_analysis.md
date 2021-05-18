# Deep Links Approaches Analysis
> Feature description / User story.

As a User, I want to pass direct links to project and/or project groups, so that other users can navigate more easily.

# Analysis
> Describe general analysis approach.

During the analysis stage we are going to investigate the implementation approaches for deep linking in Metrics Web application and chose the most suitable one for us.

### Feasibility study
> A preliminary study of the feasibility of implementing this feature.

Since the Flutter [supports deep links](https://flutter.dev/docs/development/ui/navigation/deep-linking) we are able to implement the deep linking in the Metrics Web application.

### Requirements
> Define requirements and make sure that they are complete.

- Possibility to handle deep links;
- Possibility to generate deep links in response to UI events (filtering, dropdown selections, searching, etc.);
- Extensible and testable implementation approach.

### Landscape
> Look for existing solutions in the area.

#### Deep linking approach
There are two main approaches for deep linking implementation: query parameters and path segments.   
Let's review them in more details:

- Query parameters   
  `metrics.web.app/dashboard?project=web_app`   
  Usually query parameters are used to represent the filtering and grouping criteria. Such an approach allows combining several search parameters (e.g. `project` and `project group`)

- Path segments    
  `metrics.web.app/dashboard/projects/web_app`  
  Path segments are usually used to identify the specific resource. They are more user-friendly and readable than the query parameters, but are less flexible, because you can't combine several parameters (e.g. several `project group`s).
 
According to the [requirements](#requirements) listed above, we need to respond to the dynamic UI events, such as searching and filtering, thus the query parameters approach is more suitable for utilizing in the Metrics Web Application.

#### Deep linking in the Metrics Web application
(Using notifier vs straight using route parameters)

### Prototyping
> Create a simple prototype to confirm that implementing this feature is possible.

### System modeling
> Create an abstract model of the system/feature.
