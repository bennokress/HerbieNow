# HerbieNow
[![Build Status](https://travis-ci.com/bennokress/HerbieNow.svg?token=nskHPc4LqD2upxe1tvEj&branch=master)](https://travis-ci.com/bennokress/HerbieNow) ![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg) ![Swift Version](https://img.shields.io/badge/Swift-3.1-blue.svg) [![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=58259458907fa20100b7f7c4&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/58259458907fa20100b7f7c4/build/latest)

HerbieNow is an app project by team 6 of the "Praktikum iOS Entwicklung" at the LMU. It's goal is to provide a different approach to car sharing than the official DriveNow and Car2Go apps do. The experience will be based on filters by parsing the data gathered from the respective APIs to get more detailed information on the vehicles. The filters will include horse power, special equipment, distance to fueling bonus and more.

## Course Goals

### Mandatory:
- [ ] DriveNow Connection with extended filtering options
- [ ] Car2Go Connection with equivalent filtering options
- [ ] Map View with available vehicles in accordance with the selected filters
- [ ] Appropriate storage of user information (username, password)
- [ ] Appropriate storage of filter settings
- [ ] Provided option to reserve cars

### Optional:
- [ ] Apple Watch App with one button to reserve the nearest vehicle in accordance with a user selected combination of filters
- [ ] Apple Watch App provides an option to open and lock a reserved vehicle
- [ ] Siri Integration to reserve a car by voice command
- [ ] Siri Integration to select filter options by voice command

## Installation Instructions
To start working on this project, make sure to load the frameworks after checking out the repository. To do this, you need to follow these instructions:
* Install [Homebrew](http://brew.sh/) on your Mac as described on their [website](http://brew.sh/)
* After completion run `brew install carthage` in Terminal
* To confirm that [Carthage](https://github.com/Carthage/Carthage) is installed, run `carthage version` which should result in `0.18.1` or higher
* Type `cd ` and drag the folder containing the HerbieNow-project into your Terminal window, then press enter
* Finally run `carthage bootstrap` which fetches and builds the frameworks at the version found in Cartfile.resolved

Keep in mind, that if you need to update frameworks, you have to run `carthage update --platform iOS`, which in turn also updates Cartfile.resolved. Commit the new Cartfile.resolved, if everything is working as expected with the new versions, so that other project contributors can safely update their dependencies by running `carthage bootstrap` again.
