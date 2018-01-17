# == Class oxidized::config
#
# This class is called from oxidized for service config.
#
class oxidized::config inherits oxidized {

  $config_dir   = $oxidized::config_dir
  $config_file  = "${config_dir}/config"
  $routerdb     = "${config_dir}/router.db"
  $devices      = $oxidized::devices
  $options      = $oxidized::main::merged_options
  $base_options = $oxidized::main_options

  if $oxidized::ensure =~ /(present|installed|latest)/ {
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
      mode    => '0440',
      content => template("${module_name}/routerdb.erb"),
      require => File[$config_dir],
    }
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

    file { $data_dir: 
      ensure => directory,
      owner  => $oxidized::user,
      group  => $oxidized::group,
      mode   => '0640',
    }

    concat { $config_file:
      ensure => present,
      owner  => $oxidized::user,
      group  => $oxidized::group,
      mode   => '0440',
      notify => Service[$oxidized::service_name],
    }
    Concat::Fragment {
      target => $config_file,
    }

    if empty($oxidized::custom_config_file) {
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
        content => template("${module_name}/config/header.erb"),
        order   => '10',
      }
      if empty($base_options) {
        concat::fragment { "${config_file}__custom":
          content => file("${module_name}/${oxidized::custom_config_file}"),
          order   => '20',
        }
      }
    }
  }
  elsif $oxidized::ensure == /absent/ {
    file { $config_dir:
      ensure => absent,
    }
    file { $routerdb:
      ensure  => absent,
    }
    group { $oxidized::group:
      ensure => absent,
    }
    user { $oxidized::user:
      ensure     => absent,
    }
    file { $config_file:
      ensure => absent,
    }
  }

}
