# Feature design
> Feature description / User story.

## Contents

In this section, provide the contents for the document including all custom subsections created.

- [**Analysis**](#analysis)
    - [Feasibility study](#feasibility-study)
    - [Requirements](#requirements)
    - [Landscape](#landscape)
    - [Prototyping](#prototyping)
    - [System modeling](#system-modeling)
- [**Design**](#design)
    - [Architecture](#architecture)
    - [User Interface](#user-interface)
    - [Database](#database)
    - [Privacy](#privacy)
    - [Security](#security)
    - [Program](#program)

# Analysis
> Describe a general analysis approach.

In this section, describe the methodology to feature analysis, possible solutions, and areas that need to be explored, ways to compare alternatives. It should be a brief plan for all sub-sections.

_**Important Note**: Avoid excessive details in the Analysis subsections. Think about the feature at the very top-level abstraction. Provide the details only where necessary (e.g. in the [Prototyping](#prototyping) section)._

### Feasibility study
> A preliminary study of the feasibility of implementing this feature.

One should answer the following:

- How this feature would help end-users and would they use it?
- Does this feature meet the project's scope?
- Does this feature fit the project's purpose?

### Requirements
> Define requirements and make sure that they are complete.

This section should cover the requirements of the feature. One should follow the next guide tips working on this section:

- list all the requirements for the feature in details;
- make sure the requirements are clear and complete;
- think about edge cases and if there are missing requirements;
- clarify the requirements by answering possible questions (_What if ...?_).

The described requirements should become acceptance criteria for the feature and its parts under development.

### Landscape
> Look for existing solutions in the area.

In this section, one should select the general implementation approach for the feature under analysis. The purpose is to answer the question: **"Is this going to be a custom solution or the existing one is to be used?"**.

One should review the existing solutions in the area and capture all relevant references, snippets, excerpts that would help to make an informed decision.

The general algorithm in this section is following:

1. List the existing packages/solutions/approaches for the feature.
2. List the pros & cons of each solution. This step may be optional if the solution is preliminary custom.
3. Select the solution (or conclude the solution is custom) and explain your choice.

_**Note**: The implementing approach shouldn't be a diagram, algorithm, etc. This should be a top-level approach to implement the desired feature. The selected approach must state whether the implementation should be custom or use the existing solution (e.g. package, library), or improve the existing solution to fit requirements._

### Prototyping
> Create a simple prototype to confirm that implementing this feature is possible.

Using the selected approach, one should provide prototypes for all high-risk requirements. High-risk means the ones that we are not sure that it's possible to implement in a reasonable time frame while applying best practices.

Generally speaking, in the [Feasibility study](#feasibility-study) and [Landscape](#landscape) section, one states the solution is possible. In this section, one should prove this statement with prototypes and provide profs in a form of code snippets/sample application.

_**Note**: Prototypes must cover the possible problems and edge cases for the feature, and exemplify how to solve them. There is no need to deep dive into such cases - the [Design](#design) section should discover details. Instead, prototypes should expose that the selected approach provides a convenient way to handle edge cases._

### System modeling
> Create an abstract model of the system/feature.

The purpose of this section is to discover the relation of the new feature to the existing project's implementations. In general, the section should examine the feature's place in the project's world. To archive this goal, one should consider the existing components/modules of the project and think of the feature as such. Then, answer the following:

- Is the new feature a part of the existing component? Does it complement or improve/upgrade this component?
- Is the new feature should be a part of a standalone component? How this component is going to interact with other components?

The above questions are focused on one purpose: the place and role of the new feature. To simplify reasoning, one may use the component or other diagrams in this section.

# Design

### Architecture
> Fundamental structures of the feature and context (diagram).

### User Interface
> How users will interact with the feature (API, CLI, Graphical interface, etc.).

### Database
> How relevant data will be persisted and protected.

### Privacy
> Privacy by design. Explain how privacy is protected (GDPR, CCPA, HIPAA, etc.).

### Security
> How relevant data will be secured (Data encryption at rest, etc.).

### Program
> Detailed solution description to class/method level.
