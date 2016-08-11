# == Class oxidized::config
#
# This class is called from oxidized for service config.
#
class oxidized::config {

  concat { $oxidized::params::oxidized_config:
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  concat::fragment { 'global config':
    target  => $oxidized::params::oxidized_config,
    content => template("${module_name}/main_options.erb"),
    order   => '00'
  }

}
