# HerbieNow
![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)

HerbieNow is based on an app project by team 6 of the "Praktikum iOS Entwicklung" at the LMU. It's goal is to provide a different approach to carsharing than the official DriveNow app does. The experience will be based on filters by parsing the data gathered from the official DriveNow API to get more detailed information on the vehicles. The filters will include horse power, special equipment, distance to fueling bonus and more.

## Installation Instructions
To start working on this project, make sure to load the frameworks after checking out the repository. To do this, you need to follow these instructions:
* Install [Homebrew](http://brew.sh/) on your Mac as described on their [website](http://brew.sh/)
* After completion run `brew install carthage` in Terminal
* To confirm that [Carthage](https://github.com/Carthage/Carthage) is installed, run `carthage version` which should result in `0.18.1` or higher
* Type `cd ` and drag the folder containing the HerbieNow-project into your Terminal window, then press enter
* Finally run `carthage bootstrap --platform iOS` which fetches and builds the frameworks at the version found in Cartfile.resolved for iOS

Keep in mind, that if you need to update frameworks, you have to run `carthage update --platform iOS`, which in turn also updates Cartfile.resolved. Commit the new Cartfile.resolved, if everything is working as expected with the new versions, so that other project contributors can safely update their dependencies by running `carthage bootstrap --platform iOS` again.
