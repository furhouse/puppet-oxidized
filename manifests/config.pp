# == Class oxidized::config
#
# This class is called from oxidized for service config.
#
class oxidized::config inherits oxidized {

  $config_dir  = $oxidized::config_dir
  $config_file = "${config_dir}/config"
  $routerdb    = "${config_dir}/router.db"
  $devices     = $oxidized::devices
  $options     = $oxidized::main::merged_options

  file { $config_dir:
    ensure => directory,
    owner  => $oxidized::user,
    group  => $oxidized::group,
    mode   => '0640',
  }

  file { $routerdb:
    ensure  => file,
    owner   => $oxidized::user,
    group   => $oxidized::group,
    mode    => '0640',
    content => template("${module_name}/routerdb.erb"),
    require => File[$config_dir],
  }

  if $oxidized::manage_user {
    group { $oxidized::group:
      ensure => present,
      system => true,
    }
    user { $oxidized::user:
      ensure     => present,
      shell      => '/bin/false',
      gid        => $oxidized::group,
      home       => $config_dir,
      managehome => false,
      system     => true,
    }
  }

  concat { $config_file:
    owner => $oxidized::user,
    group => $oxidized::group,
    mode  => '0440',
  }

  Concat::Fragment {
    target  => $config_file,
  }

  if empty($oxidized::config_file_template) {
    concat::fragment { "${config_file}__header":
      target  => $config_file,
      content => template("${module_name}/config/header.erb"),
      order   => '10',
    }

    if !empty($options) {
      concat::fragment { "${config_file}__options":
        target  => $config_file,
        content => template("${module_name}/config/main_options.erb"),
        order   => '20',
      }
    }
  }
  else {
    concat::fragment { "${config_file}__header":
      content => template($oxidized::config_file_template),
      order   => '10',
    }
  }

}
