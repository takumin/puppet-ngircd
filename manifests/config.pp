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
    file { "$::ngircd::self_ca_dir":
      ensure  => directory,
      owner   => 0,
      group   => 0,
      mode    => '0700',
      require => File["$::ngircd::config_dir"]
    }

    $subj_args = "/C=$::ngircd::self_ca_C/ST=$::ngircd::self_ca_ST/L=$::ngircd::self_ca_L/O=$::ngircd::self_ca_O/OU=$::ngircd::self_ca_OU/CN=$::ngircd::self_ca_CN/E=$::ngircd::self_ca_E/"

    exec { 'OpenSslGenrsa: ngircd':
      command => 'openssl genrsa -out server.key 2048',
      path    => [
        '/usr/local/bin',
        '/usr/bin',
      ],
      cwd     => [
        "$::ngircd::self_ca_dir",
      ],
      creates => [
        "$::ngircd::self_ca_dir/server.key",
      ],
      require => [
        File["$::ngircd::self_ca_dir"],
      ],
    }


    exec { 'OpenSslReq: ngircd':
      command => "openssl req -out server.csr -new -key server.key -subj $subj_args -batch",
      path    => [
        '/usr/local/bin',
        '/usr/bin',
      ],
      cwd     => [
        "$::ngircd::self_ca_dir",
      ],
      creates => [
        "$::ngircd::self_ca_dir/server.csr",
      ],
      require => [
        File["$::ngircd::self_ca_dir"],
        Exec['OpenSslGenrsa: ngircd'],
      ],
    }

    exec { 'OpenSslX509: ngircd':
      command => 'openssl x509 -out server.crt -in server.csr -signkey server.key -days 365 -req',
      path    => [
        '/usr/local/bin',
        '/usr/bin',
      ],
      cwd     => [
        "$::ngircd::self_ca_dir",
      ],
      creates => [
        "$::ngircd::self_ca_dir/server.crt",
      ],
      require => [
        File["$::ngircd::self_ca_dir"],
        Exec['OpenSslGenrsa: ngircd'],
        Exec['OpenSslReq: ngircd'],
      ],
    }

    exec { 'OpenSslGenDh: ngircd':
      command => 'openssl dhparam 2048 -out dhparam.pem',
      path    => [
        '/usr/local/bin',
        '/usr/bin',
      ],
      cwd     => [
        "$::ngircd::self_ca_dir",
      ],
      creates => [
        "$::ngircd::self_ca_dir/dhparam.pem",
      ],
      require => [
        File["$::ngircd::self_ca_dir"],
      ],
    }
  }

}
