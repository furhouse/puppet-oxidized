# == Class oxidized::params
#
# This class is meant to be called from oxidized.
# It sets variables according to platform.
#
class oxidized::params {

  if $::operatingsystem == 'Ubuntu' {
    if versioncmp($::operatingsystemrelease, '16.04') < 0 {
      fail("Unsupported version ${::operatingsystemrelease}")
    } elsif versioncmp($::operatingsystemrelease, '18.04') == 0 {
      $dependencies  = [ 'ruby', 'ruby-dev', 'libsqlite3-dev', 'libssl1.0-dev', 'pkg-config', 'cmake', 'libssh2-1-dev' ]
      $service_provider = 'systemd'
    } else {
      $dependencies  = [ 'ruby', 'ruby-dev', 'libsqlite3-dev', 'libssl-dev', 'pkg-config', 'cmake', 'libssh2-1-dev' ]
      $service_provider = 'systemd'
    }
  } elsif $::operatingsystem == 'Debian' {
    if versioncmp($::operatingsystemrelease, '8.0') < 0 {
      fail("Unsupported version ${::operatingsystemrelease}")
    } else {
      $dependencies  = [ 'ruby', 'ruby-dev', 'libsqlite3-dev', 'libssl-dev', 'pkg-config', 'cmake', 'libssh2-1-dev' ]
      $service_provider = 'systemd'
    }
  } elsif $::operatingsystem =~ /CentOS|RedHat/ {
    if versioncmp($::operatingsystemrelease, '6.0') < 0 {
      fail("Unsupported version ${::operatingsystemrelease}")
    } elsif versioncmp($::operatingsystemrelease, '7.0') < 0 {
      $dependencies  = [ 'cmake' ]
      $service_provider = 'upstart'
    } else {
      $dependencies  = [ 'cmake', 'sqlite-devel', 'openssl-devel', 'libssh2-devel', 'ruby', 'gcc', 'ruby-devel' ]
      $service_provider = 'systemd'
    }
  } else {
    fail("Your plattform ${::operatingsystem} is not supported, yet.")
  }

  $ensure_package       = present
  $main_options         = {}
  $username             = 'oxidized'
  $password             = 'oxidized'
  $gem                  = true
  $gem_names            = [ 'oxidized', 'oxidized-script', 'oxidized-web' ]
  $package_names        = []
  $custom_config_file   = undef
  $config_dir           = '/etc/oxidized'
  $pid_dir              = '/var/run/oxidized'
  $manage_user          = true
  $manage_service       = true
  $service_name         = 'oxidized'
  $service_state        = running
  $service_enable       = true
  $user                 = 'oxidized'
  $group                = 'oxidized'
  $devices              = ['localhost']
  $manage_with_rvm      = true
  $rvm_ruby_version     = '2.1.2'
  $rvm_system_default   = true
  $rvm_build_opts       = ['--binary']

  $default_options = {
    model      => 'junos',
    interval   => 3600,
    use_syslog => true,
    pid        => '/var/run/oxidized/oxidized.pid',
    debug      => false,
    threads    => 30,
    timeout    => 20,
    retries    => 3,
    prompt     => '!ruby/regexp /^([\w.@-]+[#>]\s?)$/',
    vars       => {},
    groups     => {},
    model_map  => {},
    rest       => '127.0.0.1:8888',
    input      => {
      'default'  => 'ssh, telnet',
      debug    => false,
      ssh      => {
        secure => false,
      },
    },
    output     => {
      'default' => 'git',
        git      => {
          user   => 'Oxidized',
          email  => 'oxidized@example.com',
          repo   => '~/.config/oxidized/oxidized.git',
        },
    },
    source      => {
      'default' => 'csv',
      'csv' => {
        'file'      =>  '/etc/oxidized/router.db',
        'delimiter' => ':',
        'map'       => {
            'name'  => 0,
            'model' => 1,
        },
      },
    },
    hooks => {},
  }

}
