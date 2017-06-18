# == Class oxidized::service
#
# This class is meant to be called from oxidized.
# It ensure the service is running.
#
class oxidized::service inherits oxidized {

  if $oxidized::manage_service {
    case $oxidized::service_provider {
      'systemd': {
        include ::systemd
        file { "/etc/systemd/system/${module_name}.service":
          ensure => file,
          owner  => 'root',
          group  => 'root',
          mode   => '0644',
          source => "puppet:///modules/${module_name}/${module_name}.service",
        }
        ~> Exec['systemctl-daemon-reload']
      }
      'init': {
        file { "/etc/init.d/${module_name}":
          ensure => file,
          owner  => 'root',
          group  => 'root',
          mode   => '0644',
          source => "puppet:///modules/${module_name}/${module_name}.init",
        }
      }
      default: {
        fail("Unsupported \$oxidized::service_provider, OS family: ${::osfamily}")
      }
    }

    file { '/var/run/oxidized':
      ensure => 'directory',
      owner  => $oxidized::user,
      group  => $oxidized::group,
      mode   => '0711',
    }

    service { $oxidized::service_name:
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      require    => File['/var/run/oxidized'],
    }
  }

}
