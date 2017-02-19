# == Class oxidized::config
#
# This class is called from oxidized for service config.
#
class oxidized::config {

  concat { $oxidized::params::oxidized_config:
    ensure => present,
    owner  => $oxidized::oxidized_user,
    group  => $oxidized::oxidized_group,
    mode   => '0644',
  }

  file {
    '/etc/oxidized':
        ensure => directory,
        owner  => $oxidized::oxidized_user,
        group  => $oxidized::oxidized_group,
        mode   => '0640';
  }

  concat::fragment { 'global_oxidized_config':
    target  => $oxidized::params::oxidized_config,
    content => template("${module_name}/main_options.erb"),
    order   => '00'
  }

}
