# == Class oxidized::params
#
# This class is meant to be called from oxidized.
# It sets variables according to platform.
#
class oxidized::params {

  if $::operatingsystem == 'Ubuntu' {
    if versioncmp($::operatingsystemrelease, '16.04') < 0 {
      fail("Unsupported version ${::operatingsystemrelease}")
    } else {
      $dependencies  = [ 'ruby', 'ruby-dev', 'libsqlite3-dev', 'libssl-dev', 'pkg-config', 'cmake', 'libssh2-1-dev' ]
      $package_names = [ 'rubygem-oxidized', 'rubygem-oxidized-web', 'rubygem-oxidized-script' ]
      $service_provider = 'systemd'
    }
  } elsif $::operatingsystem == 'Debian' {
    if versioncmp($::operatingsystemrelease, '8.0') < 0 {
      fail("Unsupported version ${::operatingsystemrelease}")
    } else {
      $dependencies  = [ 'ruby', 'ruby-dev', 'libsqlite3-dev', 'libssl-dev', 'pkg-config', 'cmake', 'libssh2-1-dev' ]
      $package_names = [ 'rubygem-oxidized', 'rubygem-oxidized-web', 'rubygem-oxidized-script' ]
      $service_provider = 'systemd'
    }
  } elsif $::operatingsystem =~ /CentOS|RedHat/ {
    if versioncmp($::operatingsystemrelease, '6.0') < 0 {
      fail("Unsupported version ${::operatingsystemrelease}")
    } elsif versioncmp($::operatingsystemrelease, '7.0') < 0 {
      $dependencies  = [ 'cmake', 'sqlite-devel', 'openssl-devel', 'libssh2-devel', 'ruby', 'gcc', 'ruby-devel' ]
      $package_names = [ 'ruby200-rubygem-oxidized', 'ruby200-rubygem-oxidized-web', 'ruby200-rubygem-oxidized-script' ]
      $service_provider = 'init'
    } else {
      $dependencies  = [ 'cmake', 'sqlite-devel', 'openssl-devel', 'libssh2-devel', 'ruby', 'gcc', 'ruby-devel' ]
      $package_names = [ 'rubygem-oxidized', 'rubygem-oxidized-web', 'rubygem-oxidized-script' ]
      $service_provider = 'systemd'
    }
  } else {
    fail("Your plattform ${::operatingsystem} is not supported, yet.")
  }

  $password             = undef
  $gem                  = true
  $gem_names            = [ 'oxidized', 'oxidized-script', 'oxidized-web' ]
  $config_file_template = undef
  $config_dir           = '/etc/oxidized'
  $manage_user          = true
  $manage_service       = true
  $service_name         = 'oxidized'
  $user                 = 'oxidized'
  $group                = 'oxidized'
  $devices              = ['localhost']

  $default_options = {
    username   => 'oxidized',
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
