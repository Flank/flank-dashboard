# Coverage Converter design

> Summary of the proposed change

An explanation of the Coverage Converter tool architecture design.

# References

> Link to supporting documentation, GitHub tickets, etc.

- [CI integrations coverage report structure](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/01_ci_integration_module_architecture.md#coverage-importing)
- [LCOV Code Coverage](https://wiki.documentfoundation.org/Development/Lcov)
- [Istanbul](https://istanbul.js.org/)

# Motivation

> What problem is this project solving?

Importing CI builds coverage data into the Metrics application could be tricky as there are many coverage formats and tools like Instanbul, LCOV, etc... To simplify integration we need to create a tool that can be used to convert coverage data from specific coverage tool output format into Metrics coverage format - the Coverage Converter tool. To make the Coverage Converter tool architecture clean and understandable, we need to create a document that will explain the main components and principles of the Coverage tool.

# Goals

> Identify success metrics and measurable goals.

- Explain the purpose of the Coverage Converter tool.
- Explain the main components of the Coverage Converter tool.
- Explain adding the new specific format converter to the Coverage Converter tool.

# Non-Goals

> Identify what's not in scope.

The document does not explain and shows the implementation details.

# Design

> Explain and diagram the technical design

## Main interfaces and classes

The main purpose of this tool is to convert the given supported coverage report to the [CI integrations format](https://github.com/platform-platform/monorepo/blob/master/metrics/ci_integrations/docs/01_ci_integration_module_architecture.md#coverage-report-format). To do so, we should create the following interfaces and abstract classes:

- The `CoverageConverterCommand`  - the common code coverage command that should be extended to implement a specific coverage converter.  
- The `CoverageConverter` interface that will represent the common interface for converting the specific coverage report format to the `CI integrations` coverage report format.

Let's consider the class diagram explaining the main interfaces and dependencies between them: 

![Interfaces diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/platform-platform/monorepo/master/metrics/coverage_converter/docs/diagrams/coverage_interfaces_diagram.puml)

As we can see above, the `CoverageConverterCommand` uses the `CoverageConverter` to convert the specific coverage report to the `CoverageData` class that represents the `CI integrations` coverage report.

Let's consider the activity diagram of the coverage conversion process: 

![Coverage conversion diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/coverage_converter/docs/diagrams/coverage_conversion_activity.puml)

## Error handling

As we can see in the diagram above, we should check if the input file exists and can be parsed using the chosen converter command and throw a `CoverageConverterException` if it is not.

Let's consider the class diagram representing the exceptions package structure: 

![Converter exception class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/coverage_converter/docs/diagrams/converter_exception_class_diagram.puml)

So, we have a `CoverageConverterException`, as we've mentioned above, and the `CoverageConverterErrorCode` that represents the different error codes. The `CoverageConverterException` should take a `CoverageConverterErrorCode` in the constructor and provide an error message based on the given `CoverageConverterErrorCode`. The `toString` method of the `CoverageConverterException` should return the `message`.

All exceptions should be handled on the very top level - the `main` function. So, the `main` function will contain the try-catch block that will handle all exceptions, print them, and exit the app with code `1`.

## CLI design

To run the command line application, we should have a `CommandRunner` class. Let's name it `CoverageConverterRunner`. This class will extend `CommandRunner`. It will be the place where we'll add our specific `CoverageConverterCommand`s.

Also, we should be able to pass the following arguments to the Coverage Converter tool: 

- `input` - the file from where we'll read the specific coverage report;
- `output` - the file to which we'll write the formatted coverage report. If the `output` parameter is not specified, we should use the `coverage-summary.json`.

To be able to pass arguments to our application, we should create a `CoverageConverterArgumentsManager` that will have such methods: 

- `configureArguments` - a method needed to configure the `ArgParser` with the proper options/flags;
- `parseArgResults` - a method needed to parse the `ArgResults` class returned by the `ArgParser` to the `CoverageConverterArguments` object.

We should inject the `CoverageConverterArgumentsManager` to the `CoverageConverterCommand` to be able to test the `CoverageConverterCommand` without any dependencies on `CoverageConverterArgumentsManager`. 

So, the `CoverageConverterCommand` will contain the `CoverageConverterArgumentsManager` and configure its `ArgParser` using the `configureArguments` method in the constructor body.

## Package structure

Once we've finished with all main classes and interfaces, let's consider the package structure of the `Coverage Converter`: 

> lib
>   - arguments
>     - model
>     - parser
>   - common 
>     - exception
>       - error_codes
>     - command
>     - runner
>     - converter
>   - specific_format
>     - command
>     - model
>     - converter


## Creating a new specific format converter

Once we have a `CoverageConverterCommand` abstract class, the `CoverageConverter` interface, and the `CoverageConverterRunner`,  we can create the first specific coverage parser. To implement it, we should follow the next steps: 

1. Create a specific implementation of the `CoverageConverter`.
2. Create a specific command extending the `CoverageConverterCommand` that will use the specific `CoverageConverter` created in the previous step.
3. Add the previously created `CoverageConverterCommand` to the `CoverageConverterRunner` using the `addCommand` method.

Currently, the Coverage Converter tool should support the following coverage report formats: 

- LCOV
- Istanbul

## Summary

Finally, let's consider the class diagram that provides information about all classes and their relationships.

![Coverage class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/coverage_converter/docs/diagrams/coverage_class_diagram.puml)

So, the application takes the arguments, parses them using the `CoverageConverterArgumentsManager`, and passes these arguments to the specific converter command. The converter command, in its turn, gets the input file path, converts it to the CI integrations coverage format, and writes it to the output file.

Let's consider the sequence diagram of these processes taking the `specific` format as an example:

![Coverage sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/master/metrics/coverage_converter/docs/diagrams/coverage_sequence_diagram.puml)

# Dependencies

> What is the project blocked on?

This project has no blockers.

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

  - Coverage Converter design.

NEXT:

  - Create main classes and interfaces.
  - Implement Coverage converter for the `lcov` format.
  - Implement Coverage converter for the `istanbul` format.
  
# Results

> What was the outcome of the project?

Coverage converter tool design complete and ready for implementation.
