# Class: oxidized
# ===========================
#
# === Parameters:
#
# $ensure::               Whether Oxidized and its dependencies should be present.
#
# $main_options::         A hash with all the main settings, minus the username and password.
#
# $username::             Main Oxidized username.
#
# $password::             Main Oxidized password.
#
# $gem::                  Wheter to install Oxidized as ruby gem.
#
# $gem_names::            Oxidized, oxidized-web and oxidized-script gem names.
#
# $package_names::        Oxidized, oxidized-Web and oxidized-script package names.
#
# $manage_service::       Manage the Oxidized service.
#
# $manage_user::          Manage the Oxidized user and group.
#
# $service_provider::     Specify the service provider.
#
# $service_name::         Specify the service name.
#
# $service_state          Specify the service state.
#
# $service_enable         Specify if the service is enabled.
#
# $config_dir::           Specify the Oxidized configuration directory.
#
# $pid_dir::              Specify the Oxidized pid directory.
#
# $user::                 Specify the name of the Oxidized system user.
#
# $group::                Specify the name of the Oxidized system group.
#
# $devices::              Specify an array of devices to be backed up by Oxidized.
#
# $custom_config_file     Provide your own config, from a file.
#
# $manage_with_rvm::      Specify whether the gems should be installed with rvm, on RHEL/CentOS 6.
#
# $rvm_ruby_version::     Specify the ruby version to be installed with rvm, on RHEL/CentOS 6.
#
# $rvm_system_default::   Whether the ruby version installed with rvm should be system default, on RHEL/CentOS 6.
#
# $rvm_build_opts::       Specify an array of build options for rvm, on RHEL/CentOS 6.
#
class oxidized (
  Enum['latest', 'present', 'installed', 'absent'] $ensure = $oxidized::params::ensure_package,
  Hash[String,Data] $main_options                          = $oxidized::params::main_options,
  String $username                                         = $oxidized::params::username,
  String $password                                         = $oxidized::params::password,
  Boolean $gem                                             = $oxidized::params::gem,
  Array[String] $gem_names                                 = $oxidized::params::gem_names,
  Array[String] $package_names                             = $oxidized::params::package_names,
  Boolean $manage_service                                  = $oxidized::params::manage_service,
  Boolean $manage_user                                     = $oxidized::params::manage_user,
  String $service_provider                                 = $oxidized::params::service_provider,
  String $service_name                                     = $oxidized::params::service_name,
  String $service_state                                    = $oxidized::params::service_state,
  Boolean $service_enable                                  = $oxidized::params::service_enable,
  Stdlib::Absolutepath $config_dir                         = $oxidized::params::config_dir,
  Stdlib::Absolutepath $pid_dir                            = $oxidized::params::pid_dir,
  String $user                                             = $oxidized::params::user,
  String $group                                            = $oxidized::params::group,
  Array[String] $devices                                   = $oxidized::params::devices,
  Optional[String] $custom_config_file                     = $oxidized::params::custom_config_file,
  Boolean $manage_with_rvm                                 = $oxidized::params::manage_with_rvm,
  String $rvm_ruby_version                                 = $oxidized::params::rvm_ruby_version,
  Boolean $rvm_system_default                              = $oxidized::params::rvm_system_default,
  Array[String] $rvm_build_opts                            = $oxidized::params::rvm_build_opts,

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
