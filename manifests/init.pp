# Class: oxidized
# ===========================
#
# Full description of class oxidized here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class oxidized (

  $main_options = {},
  $password     = $oxidized::params::password,
  $gem          = $oxidized::params::gem,
  $version      = 'present',

) inherits oxidized::params {

  validate_hash($main_options)

  if $password == undef {
    fail('Please set a password.')
  }

  # Merge hashes from multiple layer of hierarchy in hiera
  $hiera_main_options = hiera_hash("${module_name}::main_options", undef)

  $fin_main_options = $hiera_main_options ? {
    undef   => $main_options,
    default => $hiera_main_options,
  }

  class { 'oxidized::main':
    ensure  => $version,
    options => $fin_main_options,
  }

}
