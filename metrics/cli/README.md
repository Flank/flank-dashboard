# Metrics CLI

![Metrics CLI](docs/images/terminal.png)

A command-line application, that simplifies the deployment of Metrics components (Flutter Web application, Cloud Functions, Firestore Rules) and general setup.

It creates GCloud and Firebase projects, enables Firestore and other Firebase services necessary for correct Metrics Web Application working, and deploys the Metrics Web Application to the Firebase hosting. The tool downloads the source code by itself, so you don't have to check out the code from the repository before running the Metrics CLI.

_**Note**: The Metrics CLI does not collect any data you pass and using them only during the Metrics deployment by the machine on which the CLI runs._

Metrics CLI is available to install on macOS and Linux.

# Requirements

The `Metrics CLI` is based on a list of third-party CLIs. To view the recommended versions of the dependencies, please check out the [dependencies file](https://github.com/platform-platform/monorepo/blob/master/metrics/cli/recommended_versions.yaml).

# Installation

There are a couple of ways to install the `Metrics CLI`: 

- [Using the binary release](#using-the-binary-release)
- [Building from the source](#building-from-the-source)

## Using the binary release

You can download the built Metrics CLI tool from the [GitHub releases](https://github.com/platform-platform/monorepo/releases/tag/metrics-cli-snapshot) page. Select a release depending on your operating system (at the moment, it can be either `Linux` or `macOS`) and download a binary file. You can also use the following links:

- [`CLI for Linux`](https://github.com/platform-platform/monorepo/releases/download/metrics-cli-snapshot/metrics_cli_linux)
- [`CLI for macOS`](https://github.com/platform-platform/monorepo/releases/download/metrics-cli-snapshot/metrics_cli_macos)

Also, you can download the `Metrics CLI` tool using the command line tools. Let's consider the bash command to download the Metrics CLI:

```bash
curl -o <OUTPUT_PATH> -k <DOWNLOAD_URL> -L
```

Where the `<OUTPUT_PATH>` is the file path where you want to download the Metrics CLI, and the `<DOWNLOAD_URL>` is the download URL. Here are examples how to download the `Metrics CLI`:

- for `macOS`:

```bash
curl -o metrics_cli -k https://github.com/platform-platform/monorepo/releases/download/metrics-cli-snapshot/metrics_cli_macos -L
```

- for `Linux`: 

```bash
curl -o metrics_cli -k https://github.com/platform-platform/monorepo/releases/download/metrics-cli-snapshot/metrics_cli_linux -L
```

Now you can use the binary to run `Metrics CLI` commands:

```bash
metrics <command>
```

## Building from the source

If you've downloaded the [Metrics CLI](https://github.com/platform-platform/monorepo/tree/master/metrics/cli) via `git clone`, use the following command from inside the `cli` folder to build from the source:

```bash
make build
```

Now you can execute `Metrics CLI` commands using the next form:

```bash
./build/metrics <command>
``` 

# Usage

The Metrics CLI command has the following structure:

```bash
metrics <command> [arguments]
```

## Available commands

The next table lists commands with their descriptions:

| Command | Description |
| --- | --- |
| `doctor`   | Shows the version information of the third-party dependencies. |
| `deploy`   | Creates GCloud and Firebase projects for Metrics components and deploys the Metrics Web Application. |

To get more information about the particular command run the following:

```bash
metrics help <command>
```

# License

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).
