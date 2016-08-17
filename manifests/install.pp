# == Class oxidized::install
#
# This class is called from oxidized for install.
#
class oxidized::install {

  include oxidized::params

  if $oxidized::params::gem {
    package { $oxidized::params::dependencies:
      ensure  => $oxidized::main::ensure,
    } ->
    package { $oxidized::params::gem_names:
      ensure   => $oxidized::main::ensure,
      provider => gem,
    }
  }

  else {
    package { $oxidized::params::package_names:
      ensure => $oxidized::main::ensure,
    }
  }

}
