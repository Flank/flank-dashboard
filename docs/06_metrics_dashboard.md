## Metrics dashboard

Display projects and associated metrics for each project. 
For metrics definitions see [metrics definitions](05_project_metrics.md).

### Build Chart (Bar chart)
- 30 last builds with colors indicating build success/failure
- Any aborted build counted as failed
- Bar height is the time it took the build to finish (without queue time)

### Performance
- Displays "Performance" metric
- Data displayed for the last 14 builds
- The text shows average build length using data displayed - on current design screens, 
it’s 20M - meaning 20 minutes

### Builds (7 days)
- Displays "Builds" metric
- Data displayed for the last 7 days cumulative
- Text is the count of all builds in the date range

### Stability
- Displays "Stability" metric
- Data displayed for the last 30 builds

### Coverage
- Displays "Coverage" metric
- Data displayed for the last successful build