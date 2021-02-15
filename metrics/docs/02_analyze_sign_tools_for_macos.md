# Analyze and compare tools to sign and notarize Metrics CLI

- [Current state and objectives](#current-state-and-objectives)
- [Requirements](#requirements)
- [Analyzing process](#analyzing-process)
- [Decision](#decision)
- [References](#references)

## Current state and objectives

Apple's ongoing initiatives at controlling what runs on their platforms took a new turn with macOS Catalina (10.15), with required app and command-line binary signing.

[Codesign and notarize](https://developer.apple.com/documentation/xcode/notarizing_macos_software_before_distribution) enables programs downloaded from the Internet to be opened without any warnings.

To solve the described issue, the following steps is required:
 - signing the binary with a Developer ID Certificate
 - notarization (uploading the binary to Apple for approval)
 - validating code signing
 - validating notarization

Currently, Metrics binaries for macOS have not signed or notarized.

The document's goal is to investigate and analyze tools and methods that can help in signing and notarizing binaries.

## Requirements

Before we can use tools, describes below, we need to:

 - get an Apple ID
 - generate an [app specific password](https://support.apple.com/en-us/HT204397)
 - get the [Developer ID Application certificate](#developer-id-application)

### Developer ID Application

To get the certificate follow the next steps:
 1. On macOS open `Keychain Access` and select the `Keychain Access` button on the top left corner of the screen.
 2. Select the `Certificate Assistant` and then `Request a Certificate from a Certificate Authority`.
 3. Open the [following link](https://developer.apple.com/).
 4. Go to `Certificates IDs & Profiles`.
 5. Create a certificate.
 6. Choose the `Developer ID Application` from the list.
 7. Upload the signing request that we’ve created before.
 8. Download the created certificate and add it to your (default keychains) Keychain Access.
 9. Export the added certificate with the file format: `Personal information exchange(.p12)`.

Extra step:

To upload the exported certificate to the `Github Secrets`, we need to copy the base64 version:

```
base64 Certificates.p12 | pbcopy
```

And then paste the result to the `secrets`.

## Analyzing process

The analysis begins with the selection of programs and the study of their work, complexity, and popularity. This provides a comprehensive view of how to solve the given problem.

The research concludes with a short description of the tool(method), an example of the usage, and a list of pros and cons of each.

### [gon](https://github.com/mitchellh/gon)

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
 - popular tool

Cons:
 - can't be used with `sign-only` configuration

### [signing_tools](https://github.com/drud/signing_tools)

This is two `.sh` scripts that provides sign and notarize binaries.

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
 - separate scripts for sign and notarize step, so the tool can be used just for sign or notarize only
 - notarize step checks if the given binary is already signed
 - notarize step wait until notarization on the Apple's side completes
 - logs issues during the process

Cons:
 - the script's bash syntax is not easy to understand
 - does not have a single configuration file
 - not popular tool

### [notarize-cli](https://github.com/bacongravy/notarize-cli)

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
 2. sign binary using the following command: `codesign --force -s <identity-id> ./path/to/you/app -v`

Pros:
 - installation is unnecessary via npx
 - wait until notarization on the Apple's side completes
 
Cons:
 - only for notarize
 - requires xcode
 - does not check if the given file is already signed

## Decision

So after the above comparison the tool that fits our goals the most is the [gon](#gon).

We can use a single tool for a sign and notarize. To run it, we just need a single config file, where all the options for our release are stored. Also, with the execution flag, we can debug if something went wrong. And it has a good popularity, which means a less chance to get errors using the tool and more chance to take an answer for our questions in usage.

## References

- [Notarizing macOS Software Before Distribution](https://developer.apple.com/documentation/xcode/notarizing_macos_software_before_distribution)
- [code signing for macOS](https://wiki.freepascal.org/Code_Signing_for_macOS)
- [Using app-specific passwords](https://support.apple.com/en-us/HT204397)
- [gon](https://github.com/mitchellh/gon)
- [signing_tools](https://github.com/drud/signing_tools)
- [notarize-cli](https://github.com/bacongravy/notarize-cli)
- [Import codesign certificate Github Action](https://github.com/Apple-Actions/import-codesign-certs)
