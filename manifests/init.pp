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
