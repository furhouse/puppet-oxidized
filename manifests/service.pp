# == Class oxidized::service
#
# This class is meant to be called from oxidized.
# It ensure the service is running.
#
class oxidized::service inherits oxidized {

  if $oxidized::ensure =~ /(present|installed|latest)/ {
    if $oxidized::manage_service {
      case $oxidized::service_provider {
        'systemd': {
          include ::systemd::systemctl::daemon_reload
          file { "/etc/systemd/system/${$oxidized::service_name}.service":
            ensure => file,
            owner  => 'root',
            group  => 'root',
            mode   => '0644',
            source => "puppet:///modules/${module_name}/${module_name}.service",
          } ~> Class['systemd::systemctl::daemon_reload']
        }
        'upstart': {
          file { "/etc/init.d/${$oxidized::service_name}":
            ensure => file,
            owner  => 'root',
            group  => 'root',
            mode   => '0755',
            source => "puppet:///modules/${module_name}/${module_name}.init.d",
          }
        }
        default: {
          fail("Unsupported \$oxidized::service_provider, OS family: ${::osfamily}")
        }
      }
      file { $oxidized::pid_dir:
        ensure => directory,
        owner  => $oxidized::user,
        group  => $oxidized::group,
        mode   => '0711',
      }

      service { $oxidized::service_name:
        ensure     => $oxidized::service_state,
        enable     => $oxidized::service_enable,
        hasstatus  => true,
        hasrestart => true,
        require    => File[$oxidized::pid_dir],
        subscribe => File["/etc/systemd/system/${$oxidized::service_name}.service"],
      }

    }
  }
  elsif $oxidized::ensure == /absent/ {
    file { $oxidized::pid_dir:
      ensure => absent,
    }
    file { "/etc/systemd/system/${$oxidized::service_name}.service":
      ensure => absent,
    }
    file { "/etc/init.d/${$oxidized::service_name}":
      ensure => absent,
    }
  }
}
