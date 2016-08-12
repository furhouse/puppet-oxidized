# == Class oxidized::params
#
# This class is meant to be called from oxidized.
# It sets variables according to platform.
#
class oxidized::params {

  case $::osfamily {
    debian: {
      case $::operatingsystem {
        'Debian': {
          case $::lsbdistcodename {
            'jessie': {
              $dependencies  = [ 'ruby', 'ruby-dev', 'libsqlite3-dev', 'libssl-dev', 'pkg-config', 'cmake', 'libssh2-1-dev' ]
              $package_names = [ 'rubygem-oxidized', 'rubygem-oxidized-web', 'rubygem-oxidized-script' ]
            }
            default: {
              fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
            }
          }
        }
        'Ubuntu': {
          case $::lsbdistcodename {
            'xenial': {
              $dependencies  = [ 'ruby', 'ruby-dev', 'libsqlite3-dev', 'libssl-dev', 'pkg-config', 'cmake', 'libssh2-1-dev' ]
              $package_names = [ 'rubygem-oxidized', 'rubygem-oxidized-web', 'rubygem-oxidized-script' ]
            }
            default: {
              fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
            }
          }
        }
      }
    }
    redhat: {
      case $::lsbmajdistrelease {
        7: {
          $dependencies  = [ 'cmake', 'sqlite-devel', 'openssl-devel', 'libssh2-devel', 'ruby', 'gcc', 'ruby-devel' ]
          $package_names = [ 'rubygem-oxidized', 'rubygem-oxidized-web', 'rubygem-oxidized-script' ]
        }
        default: {
          fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
        }
      }
    }
    default: {
      fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
    }
  }

  $password           = undef
  $gem_names          = [ 'oxidized', 'oxidized-script', 'oxidized-web' ]
  $oxidized_config    = '/etc/oxidized.conf'

  $default_options = {
    username   => 'oxidized',
    model      => 'junos',
    interval   => '3600',
    use_syslog => true,
    pid        => '/var/run/oxidized.pid',
    debug      => false,
    threads    => '30',
    timeout    => '20',
    retries    => '3',
    prompt     => '!ruby/regexp /^([\w.@-]+[#>]\s?)$/',
    vars       => {},
    groups     => {},
    model_map  => {},
    restapi    => '127.0.0.1:8888',
    input      => {
      'default'  => 'ssh, telnet',
      debug    => false,
      ssh      => {
        secure => false,
      }
    },
    output     => {
      'default' => 'git',
        git      => {
          user   => 'Oxidized',
          email  => 'oxidized@example.com',
          repo   => '~/.config/oxidized/oxidized.git',
        }
    },
    source      => {
      'default' => 'csv',
    },
    hooks => {},
  }

}
