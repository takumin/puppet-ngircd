# == Class: ngircd
#
# Full description of class ngircd here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class ngircd (
  $prefix          = $::ngircd::params::prefix,
  $package_name    = $::ngircd::params::package_name,
  $service_name    = $::ngircd::params::service_name,
  $config_file     = $::ngircd::params::config_file,
  $config_template = $::ngircd::params::config_template,
  $self_signed     = $::ngircd::params::self_signed,
  $self_ca_dir     = $::ngircd::params::self_ca_dir,
  $self_ca_C       = $::ngircd::params::self_ca_C,
  $self_ca_ST      = $::ngircd::params::self_ca_ST,
  $self_ca_L       = $::ngircd::params::self_ca_L,
  $self_ca_O       = $::ngircd::params::self_ca_O,
  $self_ca_OU      = $::ngircd::params::self_ca_OU,
  $self_ca_CN      = $::ngircd::params::self_ca_CN,
  $self_ca_E       = $::ngircd::params::self_ca_E,
  $options         = $::ngircd::params::options,
) inherits ::ngircd::params {

  validate_absolute_path($::ngircd::prefix)
  validate_string($::ngircd::package_name)
  validate_string($::ngircd::service_name)
  validate_absolute_path($::ngircd::config_file)
  validate_string($::ngircd::config_template)
  validate_hash($::ngircd::options)

  class { '::ngircd::install': } ->
  class { '::ngircd::config': } ~>
  class { '::ngircd::service': } ->
  Class['::ngircd']
}
