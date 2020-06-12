[![release](https://img.shields.io/badge/Release-v1.5.0-blue)][release]
[![license](https://img.shields.io/github/license/Lechnio/LinuxEasyManager)][license]

 [release]: https://github.com/Lechnio/LinuxEasyManager/releases/latest "Releases · Lechnio/LinuxEasyManager"
 [license]: https://github.com/Lechnio/LinuxEasyManager/blob/develop/LICENSE "License"

# Linux Easy Manager

This tool is fully writed in bash script in order to simple use on other systems.

## Requirements

 * [Bash 4+][bash]
 * [Git][git]
 * [Apt][apt]

 [bash]: https://www.gnu.org/software/bash/ "GNU Bash"
 [git]: https://git-scm.com/ "Git"
 [apt]: https://launchpad.net/ubuntu/trusty/+package/apt "Apt package manager"

## Getting Started

It is highly recommended to use `easyManager.sh` with **Debian**, **Ubuntu** or **Kali** linux distributions.
The program has not been tested on other distributions.

Current stable release can be accessed on the master branch.

### Description

Program can be run in two different ways:
* `./easyManager.sh` running script with no arguments allows you to open interactive menu showed below.
![Main program menu](https://github.com/Lechnio/LinuxEasyManager/blob/master/rsc/img/example_selects.png)

* `easyManager.sh --help` allows you to check which features can be accessed via command line arguments.

Program has an option of automatically check for updates on each execution.
Update can be also checked by running `./easyManager.sh --update`.

## Authors
* **Jakub Frąckiewicz** - *created for training purposes* - [Lechnio](https://github.com/Lechnio)

