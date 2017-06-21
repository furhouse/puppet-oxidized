# == Class oxidized::install
#
# This class is called from oxidized for install.
#
class oxidized::install inherits oxidized  {

  if $oxidized::gem {
    if $oxidized::manage_with_rvm and $::facts['os']['family'] == 'RedHat' and $::facts['os']['release']['major'] == '6' {

      package { $oxidized::params::dependencies:
        ensure  => $oxidized::ensure,
      }

      class { '::rvm':
        system_rubies => {
          "ruby-${oxidized::rvm_ruby_version}" => {
            ensure      => $oxidized::ensure,
            default_use => $oxidized::rvm_system_default,
            build_opts  => $oxidized::rvm_build_opts,
          },
        },
        require       => Package[$oxidized::params::dependencies],
      }
      if $::facts['puppetversion'] < '4' {
        rvm_gem { "ruby-${oxidized::rvm_ruby_version}/oxidized":
          ensure => $oxidized::ensure,
        }
        rvm_gem { "ruby-${oxidized::rvm_ruby_version}/oxidized-script":
          ensure => $oxidized::ensure,
        }
        rvm_gem { "ruby-${oxidized::rvm_ruby_version}/oxidized-web":
          ensure => $oxidized::ensure,
        }
      }
      elsif $::facts['puppetversion'] >= '4' {
        $oxidized::params::gem_names.each |$gem| {
          rvm_gem { "ruby-${oxidized::rvm_ruby_version}/${gem}":
            ensure => $oxidized::ensure,
          }
        }
      }

      rvm_wrapper { 'oxidized':
        ensure      => $oxidized::ensure,
        target_ruby => "ruby-${oxidized::rvm_ruby_version}",
      }
    }
    else {

      package { $oxidized::params::dependencies:
        ensure  => $oxidized::ensure,
      }

      package { $oxidized::params::gem_names:
        ensure   => $oxidized::ensure,
        provider => gem,
      }

    }
  }

  else {
    package { $oxidized::params::package_names:
      ensure => $oxidized::ensure,
    }
  }

}
