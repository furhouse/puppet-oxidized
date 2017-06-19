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
  $ensure               = 'present',
  $main_options         = {},
  $password             = $oxidized::params::password,
  $gem                  = $oxidized::params::gem,
  $gem_names            = $oxidized::params::gem_names,
  $package_names        = $oxidized::params::package_names,
  $manage_service       = $oxidized::params::manage_service,
  $manage_user          = $oxidized::params::manage_user,
  $service_provider     = $oxidized::params::service_provider,
  $service_name         = $oxidized::params::service_name,
  $config_file_template = $oxidized::params::config_file_template,
  $config_dir           = $oxidized::params::config_dir,
  $user                 = $oxidized::params::user,
  $group                = $oxidized::params::group,
  $devices              = $oxidized::params::devices,
  $rvm_ruby_version     = $oxidized::params::rvm_ruby_version,

) inherits oxidized::params {

  # Merge hashes from multiple layer of hierarchy in hiera
  $hiera_main_options = hiera_hash("${module_name}::main_options", undef)

  $fin_main_options = $hiera_main_options ? {
    undef   => $main_options,
    default => $hiera_main_options,
  }

  class { '::oxidized::main':
    ensure   => $ensure,
    options  => $fin_main_options,
    password => $password,
  }

}
