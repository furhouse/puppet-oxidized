# Class: oxidized
# ===========================
#
# @summary Manages Oxidized
#
# @example Declaring the class
#   include '::oxidized'
#
# @param ensure Enum['latest', 'present', 'installed', 'absent'] Whether Oxidized and its dependencies should be present.
#
# @param main_options Hash[String,Data] A hash with all the main settings, minus the username and password.
#
# @param username String Main Oxidized username.
#
# @param password String Main Oxidized password.
#
# @param gem Boolean Wheter to install Oxidized as ruby gem.
#
# @param gem_names Array[String] Oxidized, oxidized-web and oxidized-script gem names.
#
# @param package_names Array[String] Oxidized, oxidized-Web and oxidized-script package names.
#
# @param manage_service Boolean Manage the Oxidized service.
#
# @param manage_user Boolean Manage the Oxidized user and group.
#
# @param service_provider String Specify the service provider.
#
# @param service_name String Specify the service name.
#
# @param service_state String Specify the service state.
#
# @param service_enable Boolean Specify if the service is enabled.
#
# @param config_dir [Stdlib::Absolutepath] Specify the Oxidized configuration directory.
#
# @param pid_dir [Stdlib::Absolutepath] Specify the Oxidized pid directory.
#
# @param user String Specify the name of the Oxidized system user.
#
# @param group String Specify the name of the Oxidized system group.
#
# @param devices Optional[Array] Specify an array of devices to be backed up by Oxidized.
#
# @param custom_config_file Optional[String] Provide your own config, from a file.
#
# @param manage_with_rvm Boolean Specify whether the gems should be installed with rvm, on RHEL/CentOS 6.
#
# @param rvm_ruby_version String Specify the ruby version to be installed with rvm, on RHEL/CentOS 6.
#
# @param rvm_system_default Boolean Whether the ruby version installed with rvm should be system default, on RHEL/CentOS 6.
#
# @param rvm_build_opts Array[String] Specify an array of build options for rvm, on RHEL/CentOS 6.
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

  class { '::oxidized::main': }

}
