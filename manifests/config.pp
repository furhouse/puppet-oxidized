# == Class oxidized::config
#
# This class is called from oxidized for service config.
#
class oxidized::config inherits oxidized {

  $config_dir  = $oxidized::oxidized_config_dir
  $config_file = "${config_dir}/config"
  $routerdb    = "${config_dir}/router.db"
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
    content => 'localhost',
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

  # concat { $oxidized::oxidized_config:
    # ensure => present,
    # owner  => $oxidized::oxidized_user,
    # group  => $oxidized::oxidized_group,
    # mode   => '0644',
  # }

  # concat::fragment { 'global_oxidized_config':
    # target  => $oxidized::params::oxidized_config,
    # content => template("${module_name}/main_options.erb"),
    # order   => '00',
  # }

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
