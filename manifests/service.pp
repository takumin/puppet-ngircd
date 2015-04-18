# == Class ngircd::service
#
# This class is meant to be called from ngircd.
# It ensure the service is running.
#
class ngircd::service {

  service { $::ngircd::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
