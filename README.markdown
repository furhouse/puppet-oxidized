#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with oxidized](#setup)
    * [What oxidized affects](#what-oxidized-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with oxidized](#beginning-with-oxidized)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

The oxidized module deploys [oxidized](https://github.com/ytti/oxidized).

## Module Description

This module sets up [oxidized](https://github.com/ytti/oxidized), a network device configuration backup tool.

The module has been tested with puppet 3.7.4+ on Debian 8 and Ubuntu 16.04. Support for RedHat/CentOS 7 hasn't been tested yet.

## Setup

### What oxidized affects

* Installation of oxidized
* Management of configuration file

### Beginning with oxidized

class { 'oxidized':
  password => 'oxidized',
}

## Usage

By default, oxidized, oxidized-script and oxidized-web are installed as gems. If
gem is set to false, regular system packages are installed. See (#limitations)
on how to build oxidized system packages.

## Reference

TBD

## Limitations

v0.1.0 is only tested on Debian 8 and Ubuntu 16.04. Currently,
service and user management isn't implemented yet. Finally, I'm using HTTP as
input source, router.db management should follow soon.

Also, $oxidized::params::package_names are based on the names of the .deb files
which I created with [fpm](https://github.com/jordansissel/fpm). These packages
are then pushed to a local apt repository.

Due to the ruby >= 2.0 dependency of the net-ssh gem, this module does not (yet)
work with Debian 7 and Ubuntu 14.04 out of the box.

## Development

Feel free to open a pull request if you see fit. I'll read up on rspec testing
in the meanwhile...

For more information, read the [module contribution guide](https://docs.puppet.com/forge/contributing.html).

## Release Notes/Contributors/Etc

If not explicitly stated otherwise, I'm only testing this module on Debian 8 and
Ubuntu 16.04.
