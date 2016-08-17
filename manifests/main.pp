# == Class: oxidized::main
#
# This class is called from oxidized for oxidized main config.
#
class oxidized::main (

  $ensure   = present,
  $password = $oxidized::params::password,
  $options  = {}

  ) inherits oxidized::params {

  if $password == undef {
    fail('Please set a password.')
  }
  
  $fin_pass = {
    password => $password,
  }

  # Merge hashes from multiple layer of hierarchy in hiera
  $hiera_options = hiera_hash("${module_name}::main::options", undef)

  $fin_options = $hiera_options ? {
    undef   => $options,
    default => $hiera_options,
  }
  
  $merged_options = merge($fin_pass, $oxidized::params::default_options, $fin_options)

  include oxidized::install
  include oxidized::config

  anchor { 'oxidized::main::start': }
  anchor { 'oxidized::main::end': }

  Anchor['oxidized::main::start'] ->
  Class['oxidized::install'] ->
  Class['oxidized::config'] ~>
  Anchor['oxidized::main::end']

}
