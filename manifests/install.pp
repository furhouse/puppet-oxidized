# == Class oxidized::install
#
# This class is called from oxidized for install.
#
class oxidized::install inherits oxidized  {

  if $oxidized::gem {
    package { $oxidized::params::dependencies:
      ensure  => $oxidized::ensure,
    }
    package { $oxidized::params::gem_names:
      ensure   => $oxidized::ensure,
      provider => gem,
      require  => Package[$oxidized::params::dependencies],
    }
  }

  else {
    package { $oxidized::params::package_names:
      ensure => $oxidized::ensure,
    }
  }

}
