# Widget structure organization
> Summary of the proposed change.

# References
> Link to supporting documentation, GitHub tickets, etc.

# Motivation
> What problem is this project solving?

# Goals
> Identify success metrics and measurable goals.

# Non-Goals
> Identify what's not in scope.

# Design
> Explain and diagram the technical design.

## View models for UI components: pros & cons.
> Give the main pros & cons of using the `view model`.

> Explain and compare two main approaches of using the `view model`.

### Plain view model

### Composite view model

## Widget creation guidelines
> Explain and diagram an algorithm for creating a new `widget`.

Main questions: 
1. Should we create a separate widget for each view? For example, Coverage and Stability widgets VS ProjectMetricPercent widget.
2. Describe the approach of applying the view model. This means we should explain exactly where we should use the view model and where we should use the base dart types.
3. Flow diagram for creating a new widget.

## Metrics Theme guidelines
> Explain and diagram the metrics theme structure.

> Explain the algorithm of applying the metrics theme to the widgets.

> Explain the algorithm of adding new theme components for new widgets.

# Dependencies
> What is the project blocked on?

No blockers.

> What will be impacted by the project?

# Alternatives Considered
> Summarize alternative designs (pros & cons).

# Results
> What was the outcome of the project?
