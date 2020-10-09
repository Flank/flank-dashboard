# CodeCov Converter design

> Summary of the proposed change

An explanation of the CodeCov Converter tool architecture design.

# References

> Link to supporting documentation, GitHub tickets, etc.

# Motivation

> What problem is this project solving?

Since we have a `CI integrations` tool that stands for importing the CI builds to the Metrics application, we need to sure that the user can use this tool with any format of the coverage reports. To do so, to do that, we should create a separate, specific for `CI integrations`, coverage report format, and the tool that will convert the coverage reports with different formats into this format - the CodeCov Converter tool. To make the CodeCov Converter tool architecture clean and understandable, we need to create a document that will explain the main components and principles of the CodeCov tool.

# Goals

> Identify success metrics and measurable goals.

- Explain the purpose of the CodeCov Converter tool.
- Explain the main components of the CodeCov Converter tool.
- Choose the way and the place of deploying the CodeCov Converter tool.

# Non-Goals

> Identify what's not in scope.

- The document does not explains and shows the implementation details.

# Design

> Explain and diagram the technical design

## Main interfaces and classes

The main purpose of this tool is to convert the given coverage report to the `CI integrations` readable one. To do so, we should create the following interfaces and abstract classes: 

- The `CodeCovConverterCommand` interface - the common code coverage command interface. 
- The `CodeCovConverter` interface that will represent the common interface for converting the specific coverage report format to the `CI integrations` coverage report format.

Let's consider the class diagram explaining the main interfaces and dependencies between them: 

![Interfaces diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/codecov_converter_design/metrics/codecov_converter/docs/diagrams/codecov_interfaces_diagram.puml)

As we can see above, the `CodeCovConverterCommand` uses the `CodeCovConverter` to convert the specific coverage report to the `CoverageModel` class that represents the `CI integrations` coverage report.

Let's consider the activity diagram of the coverage conversion process: 

![Coverage conversion diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/codecov_converter_design/metrics/codecov_converter/docs/diagrams/codecov_conversion_activity.puml)

To run the command line application we should have the `CommandRunner` class. Let's name the `CodeCovConverterRunner` class that will extend the `CommandRunner`. It will be the place where we'll add our specific `CodeCovConverterCommand`s.

Also, we should be able to pass the following arguments to the CodeCov Converter tool: 

- input - the file from where we'll read the specific coverage report;
- output - the file to which we'll write the formatted coverage report;

To be able to pass an arguments to our application we should create an `CodeCovArgumentsParser` that will take a `List<String>` as arguments and return the `CodeCovArguments` instance that will contain all given arguments.

## Package structure

Once we are done with all main classes and interfaces, let's consider the package structure of the `CodeCov Converter`: 

> lib
>   - arguments
>     - model
>     - parser
>   - common 
>     - command
>     - runner
>     - converter
>   - specific_format
>     - command
>     - model
>     - converter

## Creating a new specific format converter

Once we have a `CodeCovConverterCommand` abstract class, the `CodeCovConverter` interface, and the `CodeCovConverterRunner`,  we can create the first specific coverage parser. To implement it we should follow the next steps: 

1. Create a specific implementation of the `CodeCovConverter`.
2. Create a specific command extending the `CodeCovConverterCommand` that will use the specific `CodeCovConverter` created in the previous step.
3. Add the previously created `CodeCovConverterCommand` to the `CodeCovConverterRunner` using the `addCommand` method.

## Structure of the CodeCov coverage report.

Since we want to unify the coverage reports we should create a specific for CI integrations coverage report format. Currently, this report will contain only `line coverage percent`. 
Let's consider the JSON summary structure: 

```
{
  pct: 0.6
}
```

So, the JSON will contain only `pct` value that will represent the total line coverage percent. Let's consider the class diagram of the coverage structure: 

![Coverage class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/codecov_converter_design/metrics/codecov_converter/docs/diagrams/coverage_class_diagram.puml)

## Summary

Finally, let's consider the class diagram that provides an information about all classes and their relationships.

![CodeCov class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/codecov_converter_design/metrics/codecov_converter/docs/diagrams/codecov_class_diagram.puml)

So, the application takes the arguments on run, parses them using the `CodeCovArgumentsParser`, and passes them to the specific converter command. The converter command in it's turn gets the input file path, converts it to the CI integrations coverage format, and writs it to the output file.

Let's consider the sequence diagram of these process taking the `specific` format as an example. 

![CodeCov sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/codecov_converter_design/metrics/codecov_converter/docs/diagrams/codecov_sequence_diagram.puml)

# Dependencies

> What is the project blocked on?

This projects has no blockers.

> What will be impacted by the project?

The mechanism of loading the coverage report in the CI integrations will be impacted.

# Testing

> How will the project be tested?

The project will be tested using unit tests.

# Alternatives Considered

> Summarize alternative designs (pros & cons)

No alternatives considered.

# Timeline

> Document milestones and deadlines.

DONE:

  -

NEXT:

  - Create main classes and interfaces.
  - Implement CodeCov converter for the `lcov` format.
  - Implement CodeCov converter for the `istanbul` format.
  
# Results

> What was the outcome of the project?

Work in progress.
