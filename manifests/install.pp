# == Class ngircd::install
#
# This class is called from ngircd for install.
#
class ngircd::install {

  package { $::ngircd::package_name:
    ensure => present,
  }
}
