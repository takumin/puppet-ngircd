# == Class ngircd::config
#
# This class is called from ngircd for service config.
#
class ngircd::config {

  file { "$::ngircd::config_file":
    ensure       => file,
    owner        => 0,
    group        => 0,
    mode         => '0600',
    content      => template($::ngircd::config_template),
    validate_cmd => "$::ngircd::prefix/sbin/ngircd -t -f %",
  }

  file { "$::ngircd::config_dir":
    ensure       => directory,
    owner        => 0,
    group        => 0,
    mode         => '0755',
  }

  #
  # OpenSSL Self Sign Certification
  #
  if $::ngircd::self_signed == true {
    file { "$::ngircd::ca_dir":
      ensure  => directory,
      owner   => 0,
      group   => 0,
      mode    => '0700',
      require => File["$::ngircd::config_dir"]
    }

    exec { 'OpenSslGenrsa: ngircd':
      command => 'openssl genrsa -out server.key 2048',
      path    => [
        '/usr/local/bin',
        '/usr/bin',
      ],
      cwd     => [
        "$::ngircd::ca_dir",
      ],
      creates => [
        "$::ngircd::ca_dir/server.key",
      ],
      require => [
        File["$::ngircd::ca_dir"],
      ],
    }

    $subj_args = "/C=$::ngircd::ca_C/ST=$::ngircd::ca_ST/L=$::ngircd::ca_L/O=$::ngircd::ca_O/OU=$::ngircd::ca_OU/CN=$::ngircd::ca_CN/E=$::ngircd::ca_E/"

    exec { 'OpenSslReq: ngircd':
      command => "openssl req -out server.csr -new -key server.key -subj $subj_args -batch",
      path    => [
        '/usr/local/bin',
        '/usr/bin',
      ],
      cwd     => [
        "$::ngircd::ca_dir",
      ],
      creates => [
        "$::ngircd::ca_dir/server.csr",
      ],
      require => [
        File["$::ngircd::ca_dir"],
        Exec['OpenSslGenrsa: ngircd'],
      ],
    }

    exec { 'OpenSslX509: ngircd':
      command => 'openssl x509 -out server.crt -in server.csr -signkey server.key -days 365 -req -extensions v3_ca',
      path    => [
        '/usr/local/bin',
        '/usr/bin',
      ],
      cwd     => [
        "$::ngircd::ca_dir",
      ],
      creates => [
        "$::ngircd::ca_dir/server.crt",
      ],
      require => [
        File["$::ngircd::ca_dir"],
        Exec['OpenSslGenrsa: ngircd'],
        Exec['OpenSslReq: ngircd'],
      ],
    }
  }

}
