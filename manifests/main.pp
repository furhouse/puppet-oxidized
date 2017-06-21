# == Class: oxidized::main
#
# This class is called from oxidized for oxidized main config.
#
class oxidized::main  inherits oxidized {

  $fin_user = {
    username => $oxidized::username,
  }

  $fin_pass = {
    password => $oxidized::password,
  }

  # Merge hashes from multiple layer of hierarchy in hiera
  $hiera_options = hiera_hash("${module_name}::main_options", undef)

  $fin_options = $hiera_options ? {
    undef   => $oxidized::main_options,
    default => $hiera_options,
  }

  $merged_options = merge($fin_pass, $fin_user, $oxidized::params::default_options, $fin_options)

  include '::oxidized::install'
  include '::oxidized::config'
  include '::oxidized::service'

  anchor { 'oxidized::main::start': }
  anchor { 'oxidized::main::end': }

  Anchor['oxidized::main::start']
  -> Class['oxidized::install']
  -> Class['oxidized::config']
  -> Class['oxidized::service']
  ~> Anchor['oxidized::main::end']

}
