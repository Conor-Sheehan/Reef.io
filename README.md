# reef iOS App

Supports: iOS 10.x and above

## Branches:

* master - currently supporting deprecated BlueTooh config for Andy's Reef Unit
* develop-Wifi - development branch for updated Reef technology

## Dependencies:

The project is using cocoapods for managing external libraries and a Gemfile for managing the cocoapods version.

Get HomeBrew (if not previously installed)

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

```

Install Ruby Environment Manager (if not previously installed)

```
brew update
brew install ruby
```

Then install cocoapods (if not previously installed)

```
sudo gem install -n /usr/local/bin cocoapods
```

Then cd to the Reef Grows project directory
And run a pod install

```
cd /Your Xcode Project Directory Path
pod install
```

### Core Dependencies

* Swiftlint - A tool to enforce Swift style and conventions.
* R.swift - Get strong typed, autocompleted resources like images, fonts and segues in Swift projects
* Firebase - Cloud support for managing database, analytics, crash reports, etc

## Project structure:

* Resources - fonts, strings, images, generated files etc.
* SupportingFiles - configuration plist files
* Models - model objects
* Modules - contains app modules (UI + Code)
* Helpers - protocols, extension and utility classes

