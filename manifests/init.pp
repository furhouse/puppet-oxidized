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
  String $ensure                         = 'present',
  Hash[String,Data] $main_options        = {},
  String $password                       = $oxidized::params::password,
  Boolean $gem                           = $oxidized::params::gem,
  Array[String] $gem_names               = $oxidized::params::gem_names,
  Array[String] $package_names           = $oxidized::params::package_names,
  Boolean $manage_service                = $oxidized::params::manage_service,
  Boolean $manage_user                   = $oxidized::params::manage_user,
  String $service_provider               = $oxidized::params::service_provider,
  String $service_name                   = $oxidized::params::service_name,
  Optional[String] $config_file_template = $oxidized::params::config_file_template,
  Stdlib::Absolutepath $config_dir       = $oxidized::params::config_dir,
  String $user                           = $oxidized::params::user,
  String $group                          = $oxidized::params::group,
  Array[String] $devices                 = $oxidized::params::devices,
  String $rvm_ruby_version               = $oxidized::params::rvm_ruby_version,

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
