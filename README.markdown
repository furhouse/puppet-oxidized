[![Puppet Forge](https://img.shields.io/puppetforge/v/furhouse/oxidized.svg)](https://forge.puppet.com/furhouse/oxidized)
[![Build Status](https://travis-ci.org/furhouse/puppet-oxidized.svg?branch=master)](https://travis-ci.org/furhouse/puppet-oxidized)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with oxidized](#setup)
    * [What oxidized affects](#what-oxidized-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with oxidized](#beginning-with-oxidized)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [oxidized](#class-oxidized)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Todo](#todo)

## Overview

Downloads, installs and configures [Oxidized](https://github.com/ytti/oxidized).

## Module Description

This module installs Oxidized, a network device configuration backup tool.

## Setup

### What oxidized affects

- Installs and configures Oxidized, by default as ruby gems.
- Installs dependencies required for Oxidized ruby gems.
- Creates an oxidized system [$oxidized::user](#user) and [$oxidized::group](#group).
- Install systemd or upstart service file, based on [$oxidized::service_provider](#service_provider).
- Installs ruby 2.1.2 as system default on RHEL/CentOS 6, but manageable with a number of rvm related parameters.

### Setup Requirements

Oxidized expects ruby version >= 2.1.2 to be installed on the target system.

By default, rvm is used to install ruby 2.1.2 on RHEL/CentOS 6.

### Beginning with oxidized

To simply install oxidized without any configuration, (don't really) use:

```
class { '::oxidized': }
```

## Usage

The bare minimum is provided, and is easily overwritten by passing a hash to [$oxidized::main_options](#main_options).

```
class { '::oxidized':
  username     => 'admin',
  password     => 'ubnt',
  main_options => {
    'model'    => 'edgeos',
    'interval' => 3600,
    'log'      => '~/.config/oxidized/log',
    'debug'    => false,
    'input'    => {
      'default' => 'ssh',
      'debug'   => true,
      'secure'  => false,
    }
  }
}
```

If you're using `hiera`, you could easily migrate by passing the entire config to [$oxidized::main_options](#main_options), and specifying a [$oxidized::devices] array:

```
---
classes:
  - oxidized

oxidized::devices:
  - '192.168.2.253'
oxidized::main_options:
  username: ubnt
  password: ubnt
  model: edgeos
  interval: 3600
  use_syslog: true
  pid: "/var/run/oxidized/oxidized.pid"
  debug: false
  threads: 30
  timeout: 20
  retries: 3
  prompt: "!ruby/regexp /^([\\w.@-]+[#>]\\s?)$/"
  vars: {}
  groups: {}
  model_map: {}
  rest: '0.0.0.0:8888'
  input:
    default: 'ssh, telnet'
    debug: false
    ssh:
      secure: false
  output:
    default: git
    git:
      user: 'Oxidized'
      email: 'oxidized@example.com'
      repo: "~/.config/oxidized/oxidized.git"
  source:
    default: http
    debug: false
    http:
      url: https://librenms.example.com/api/v0/oxidized
      map:
        name: hostname
        model: os
        group: group
      headers:
        X-Auth-Token: 'gF1gryHRg665S2VvhSk750NJoR7A2eYkEsEA'
  hooks: {}
```

## Reference

### Class: `oxidized`

When this class is declared with the default options, Puppet:

- Creates a system [user](#user) and [group](#group), based on [manage_user](#manage_user).
- Installs the required dependencies so the Oxidized [gems](#gem_names) can be installed.
- Installs Oxidized, Oxidized-web and Oxidized-script, as [gems](#gem_names) if [gem](#gem) is set to true.
- Installs ruby [2.1.2](#rvm_ruby_version) with [rvm](#manage_with_rvm) on RedHat/CentOS 6, and then installs the [gems](#gem_names).
- Creates the [configuration directory](#config_dir), [configuration directory](#config_dir)/[routerdb file](#devices) and the [configuration directory](#config_dir)/config file.
- Installs a file for managing the Oxidized service, based on [service_provider](#service_provider) and [service_name](#service_name).
- Starts the Oxidized service, with [['localhost']](#devices) in the default input file.

If you would just declare the default `oxidized` class, Oxidized and its dependencies will be installed .

**Parameters within `oxidized`:**

##### `ensure`

Specify whether oxidized should be latest, present, installed, absent. Default: `present`.

```
class { '::oxidized':
  ensure => present,
}
```

##### `main_options`

Specify all Oxidized parameters by passing a hash to [$oxidized::main_options](#main_options). Default: `{}`.

See the [Oxidized README](https://github.com/ytti/oxidized#advanced-configuration) a full reference.

```
class { '::oxidized':
  main_options => {
    'model'    => 'edgeos',
    'interval' => 3600,
    'log'      => '~/.config/oxidized/log',
    'debug'    => false,
    'input'    => {
      'default' => 'ssh',
      'debug'   => true,
      'secure'  => false,
    }
  }
}
```

##### `username`

Sets the main Oxidized username, used to log into a device. Default: `oxidized`.

```
class { '::oxidized':
  username => 'oxidized',
}
```

##### `password`

Sets the main Oxidized password, used to log into a device. Default: `oxidized`.

```
class { '::oxidized':
  password => 'oxidized',
}
```

##### `gem`

Specify whether the Oxidized [$oxidized::gems](#gem_names) should be installed as rubygems. Default: `true`.

```
class { '::oxidized':
  gem => true,
}
```

##### `gem_names`

Specify an array of Oxidized gem names. Default: `['oxidized', 'oxidized-script', 'oxidized-web']`.

```
class { '::oxidized':
  gem_names => ['oxidized', 'oxidized-script', 'oxidized-web']
}
```

##### `package_names`

Specify an array of Oxidized package names. Should only be used in combination with a custom repository, after building the required Oxidized packages yourself. Default: `[]`.


```
class { '::oxidized':
  package_names => [],
}
```

##### `manage_service`

Specify whether the oxidized [$oxidized::service_name](#service_name) should be managed. Default: `true`

```
class { '::oxidized':
  manage_service => true,
}
```

##### `service_provider`

Sets the Oxidized service name. Default: Depends on your operating system (family).

- **Debian**: `systemd`
- **Red Hat/CentOS 7**: `systemd`
- **Red Hat/CentOS 6**: `upstart`

```
class { '::oxidized':
  service_provider => 'systemd',
}
```

##### `service_name`

Sets the Oxidized service name. Default: `oxidized`.

```
class { '::oxidized':
  service_name => 'oxidized',
}
```

##### `service_state`

Sets the Oxidized service state. Default: `running`.

```
class { '::oxidized':
  service_state => running,
}
```

##### `config_dir`

Sets the Oxidized configuration directory. Default: `/etc/oxidized`.

```
class { '::oxidized':
  config_dir => '/etc/oxidized',
}
```

##### `pid_dir`

Sets the Oxidized service pid directory. Default: `/var/run/oxidized`.

```
class { '::oxidized':
  pid_dir => '/var/run/oxidized',
}
```

##### `manage_user`

Specify whether the oxidized system [$oxidized::user](#user) and [$oxidized::group](#group) should be created. Default: `true`

```
class { '::oxidized':
  manage_user => true,
}
```

##### `user`

Sets the Oxidized system user. Default: `oxidized`.

```
class { '::oxidized':
  user => 'oxidized',
}
```

##### `group`

Sets the Oxidized system group. Default: `oxidized`.

```
class { '::oxidized':
  group => 'oxidized',
}
```

##### `devices`

Specify an array of devices to be backed up with Oxidized. Default: `['localhost']`.

```
class { '::oxidized':
  devices => ['localhost'],
}
```

##### `manage_with_rvm`

Specify the management of ruby by rvm. Default: `true`.

```
class { '::oxidized':
  manage_with_rvm => true,
}
```

##### `rvm_ruby_version`

Specify the ruby version to be installed by rvm. Default: `2.1.2`.

```
class { '::oxidized':
  rvm_ruby_version => '2.1.2',
}
```

##### `rvm_system_default`

Specify whether the ruby version installed by rvm should be system default. Default: `true`.

```
class { '::oxidized':
  rvm_system_default => true,
}
```

##### `rvm_build_opts`

Sets the rvm build_opts. Default: `['--binary']`.

```
class { '::oxidized':
  rvm_build_opts => ['--binary'],
}
```

##### `custom_config_file`

You can use a file for creating the configuration file. Default: `undef`.

```
class { '::oxidized':
  custom_config_file => 'my_custom_config.txt',
}
```

`oxidized/files/my_custom_config.txt`:

```
password: custom_config
username: custom_config
model: junos
interval: 3600
use_syslog: true
pid: "/var/run/oxidized/oxidized.pid"
debug: false
threads: 30
timeout: 20
retries: 3
prompt: "!ruby/regexp /^([\\w.@-]+[#>]\\s?)$/"
vars: {}
groups: {}
model_map: {}
rest: 127.0.0.1:8888
input:
  default: ssh, telnet
  debug: false
  ssh:
    secure: false
output:
  default: git
  git:
    user: Oxidized
    email: oxidized@example.com
    repo: "~/.config/oxidized/oxidized.git"
source:
  default: csv
  csv:
    file: "/etc/oxidized/router.db"
    delimiter: ":"
    map:
      name: 0
      model: 1
hooks: {}
```

## Limitations

- Does not allow versioning of the [$oxidized::gem_names](#gem_names).
- If [$oxidized::ensure](#ensure) is set to absent, the gem provider is removed before the gems, so that is failing at the moment...
- Hardcoded gem names if RHEL/CentOS 6 is used.
- Hardcoded upstart and systemd service files.
- Does not manage SELinux.

## Development

This project uses rspec-puppet and beaker to ensure the module works as expected and to prevent regressions.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Todo

- Create branch for Puppet 3.
- Template service files.
- Revisit [$osidized::ensure => absent](#ensure), especially removal of packages with `provider => gem`.
