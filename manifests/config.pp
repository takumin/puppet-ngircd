# == Class ngircd::config
#
# This class is called from ngircd for service config.
#
class ngircd::config {

  file { "$::ngircd::config_file":
    ensure       => file,
    owner        => 0,
    group        => 0,
    mode         => '0644',
    content      => template($::ngircd::config_template),
    validate_cmd => "$::ngircd::prefix/sbin/ngircd -t -f %",
  }

}
