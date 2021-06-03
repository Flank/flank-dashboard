# Feature design
> Feature description / User story.

Apple's ongoing initiatives at controlling what runs on their platforms took a new turn with macOS Catalina (10.15), with a required app and command-line binary signing.

[Codesign and notarize](https://developer.apple.com/documentation/xcode/notarizing_macos_software_before_distribution) enables programs downloaded from the Internet to be opened without any warnings.

To solve the described issue, the following steps are required:
 - signing the binary with a Developer ID Certificate
 - notarization (uploading the binary to Apple for approval)
 - validating code signing
 - validating notarization

Currently, Metrics binaries for macOS have not been signed or notarized.

The document's goal is to investigate and analyze tools and methods that can help in signing and notarizing binaries.

## References
> Link to supporting documentation, GitHub tickets, etc.

- [notarizing macOS software before distribution](https://developer.apple.com/documentation/xcode/notarizing_macos_software_before_distribution)
- [code signing for macOS](https://wiki.freepascal.org/Code_Signing_for_macOS)
- [using app-specific passwords](https://support.apple.com/en-us/HT204397)
- [gon](https://github.com/mitchellh/gon)
- [signing_tools](https://github.com/drud/signing_tools)
- [notarize-cli](https://github.com/bacongravy/notarize-cli)
- [generate sha256 hash](https://ss64.com/osx/shasum.html)
- [import codesign certificate Github Action](https://github.com/Apple-Actions/import-codesign-certs)

## Contents

- [**Analysis**](#analysis)
    - [Landscape](#landscape)
        - [gon](#gon)
        - [signing_tools](#signing_tools)
        - [notarize-cli](#notarize-cli)
        - [generate sha256 hash](#generate-sha256-hash)
        - [Decision](#decision)

# Analysis
> Describe a general analysis approach.

The analysis begins with the selection of programs and the study of their work, complexity, and popularity. This provides a comprehensive view of how to solve the given problem.

The research concludes with a short description of the tool (method), an example of the usage, and a list of pros and cons of each.

### Landscape
> Look for existing solutions in the area.

#### [gon](https://github.com/mitchellh/gon)

`gon` is a simple tool for signing and notarizing CLI binaries for macOS. It can be run manually or in automation pipelines. `gon` requires a configuration file (`.hcl` or `.json`) that can be specified as a file path or passed in via stdin. The configuration specifies all the settings tool will use to sign and package files.
Before using `gon` you should install it:

```
brew tap mitchellh/gon
brew install mitchellh/gon/gon
```

To sign and notarize CLI binary with `gon` you should run the following command:

```
gon [flags] [CONFIG]
```

where `flags` are:
 - `-log-level` - output logs in JSON format for machine readability
 - `-log-json` - log level to output (defaults to no logging) 

Pros: 
 - can be run manually or via pipelines (Github Actions etc.)
 - single file for configuration (options can be passed via stdin)
 - a debug can be enabled with `-log-json` flag
 - can be run with `notarization-only` configuration
 - notarize packages and wait for the notarization to complete
 - signed files into a `.dmg` or `.zip`
 - popular tool (top rank on Github for a sign and notarize with more than 800 stars, has a lot of contributors)

Cons:
 - can't be used with `sign-only` configuration

#### [signing_tools](https://github.com/drud/signing_tools)

These are two `.sh` scripts that provide sign and notarize binaries.

First, `macos_sign.sh` is the sign script. It accepts the following list of parameters: 
 - `--signing-password` - a password for key-chain, that the tool is creating while running;
 - `--cert-file` - a developer id application certificate, used for code sign
 - `--cert-name` - a name of the certificate
 - `--target-binary` - a specific binary

Example of usage:

```
./macos_sign.sh --signing-password="${SIGNING_TOOLS_SIGNING_PASSWORD}" --cert-file=${CERTFILE} --cert-name="${CERTNAME}" --target-binary="${TARGET_BINARY}"
```

Second, `macos_notarize.sh` is the notarize script. It accepts the following list of parameter:
 - `--app-specific-passwords` - the generated password for the application
 - `--apple-id` - an id of the apple developer account
 - `--primary-bundle-id`
 - `--target-binary` - a specific binary

 ```
 ./macos_notarize.sh --app-specific-password=${APP_SPECIFIC_PASSWORD} --apple-id=${APPLE_ID} --primary-bundle-id=com.ddev.test-signing-tools --target-binary=${TARGET_BINARY}
 ```

Pros:
 - separate scripts for a sign and notarize step, so the tool can be used just for a sign or notarize only
 - notarize step checks if the given binary is already signed
 - notarize step wait until notarization on the Apple's side completes
 - logs issues during the process

Cons:
 - the script's bash syntax is not easy to understand
 - does not have a single configuration file
 - not a popular tool (only a few GitHub stars, does not have contributors)

#### [notarize-cli](https://github.com/bacongravy/notarize-cli)

This tool is a wrapper for `xcrun altool` and `xcrun stapler`, so it requires Xcode to be installed.

There is a list of parameters:
 - `--bundle-id` - bundle id of the app to notarize (can pass via ENV)
 - `--file` - path to the file to notarize
 - `--password` - password to use for authentication (can pass via ENV)
 - `--username` - username to use for authentication (can pass via ENV)

Example of usage:

```
npx notarize-cli [OPTIONS]
```

The tool is just for notarizing we need to sign from within a separate step manually. 

To do so we can:
 1. use Github Actions (https://github.com/Apple-Actions/import-codesign-certs) to import code-sign certificates
 2. sign binary using the following command:
  
 ```
 codesign --force -s <identity-id> ./path/to/you/app -v
 ```

Pros:
 - installation is not required (runs via npx)
 - waits until notarization on Apple's side completes
 
Cons:
 - only for notarize
 - requires Xcode
 - does not check if the given file is already signed

#### [generate sha256 hash](https://ss64.com/osx/shasum.html)

This method provides an easy way to compute SHA hash for Metrics binaries.

Example of usage:
 
```
shasum -a 256 /path/to/binary
```

Pros:
 - the `shasum` command is already available on macOS
 - easy to generate with just a single command

Cons:
 - serve the additional file with a hash
 - requires an extra step for users to verify the checksum
 - no signatures generated and macOS will block such app by default - so users will have to take extra steps to run unsigned apps

#### Decision

As we've discovered, binaries compiled via `dart2native` can't be signed and notarized. The existing [issue](https://github.com/dart-lang/sdk/issues/39106) in the `dart-SDK` repo confirmed the problem.

As it is a blocker for the tools that provide codesign and notarize, we should choose the last method to sign the Metrics binaries - [generate sha256](#generate-sha256-hash) until the issue is solved.
