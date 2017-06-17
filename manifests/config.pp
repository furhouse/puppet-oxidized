# == Class oxidized::config
#
# This class is called from oxidized for service config.
#
class oxidized::config inherits oxidized {

  file { '/etc/oxidized':
    ensure => directory,
    owner  => $oxidized::oxidized_user,
    group  => $oxidized::oxidized_group,
    mode   => '0640';
  }

  if $oxidized::manage_user {
    group { $oxidized::group:
      ensure => present,
      system => true,
    }
    user { $oxidized::user:
      ensure     => present,
      shell      => '/usr/sbin/nologin',
      gid        => $oxidized::group,
      home       => '/etc/oxidized',
      managehome => false,
      system     => true,
    }
  }

  concat { $oxidized::oxidized_config:
    ensure => present,
    owner  => $oxidized::oxidized_user,
    group  => $oxidized::oxidized_group,
    mode   => '0644',
  }

  concat::fragment { 'global_oxidized_config':
    target  => $oxidized::params::oxidized_config,
    content => template("${module_name}/main_options.erb"),
    order   => '00',
  }

}
