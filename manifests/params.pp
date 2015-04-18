# == Class ngircd::params
#
# This class is meant to be called from ngircd.
# It sets variables according to platform.
#
class ngircd::params {
  case $::osfamily {
    'Debian', 'RedHat', 'Amazon': {
      $prefix          = undef
      $package_name    = 'ngircd'
      $service_name    = 'ngircd'
      $config_file     = '/etc/ngircd.conf'
      $config_template = 'ngircd/ngircd.conf.erb'
    }
    'FreeBSD': {
      $prefix          = '/usr/local'
      $package_name    = 'irc/ngircd'
      $service_name    = 'ngircd'
      $config_file     = '/usr/local/etc/ngircd.conf'
      $config_template = 'ngircd/ngircd.conf.erb'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

  #
  # Module Configuration
  #
  $options = {
    Global              => {
    Name                => undef,
    AdminInfo1          => undef,
    AdminInfo2          => undef,
    AdminEMail          => undef,
    HelpFile            => undef,
    Info                => undef,
    Listen              => undef,
    MotdFile            => undef,
    MotdPhrase          => undef,
    Password            => undef,
    PidFile             => undef,
    Ports               => undef,
    ServerGID           => undef,
    ServerUID           => undef,
    },
    Limits              => {
    ConnectRetry        => undef,
    IdleTimeout         => undef,
    MaxConnections      => undef,
    MaxConnectionsIP    => undef,
    MaxJoins            => undef,
    MaxNickLength       => undef,
    MaxListSize         => undef,
    PingTimeout         => undef,
    PongTimeout         => undef,
    },
    Options             => {
    AllowedChannelTypes => undef,
    AllowRemoteOper     => undef,
    ChrootDir           => undef,
    CloakHost           => undef,
    CloakHostModeX      => undef,
    CloakHostSalt       => undef,
    CloakUserToNick     => undef,
    ConnectIPv6         => undef,
    ConnectIPv4         => undef,
    DefaultUserModes    => undef,
    DNS                 => undef,
    Ident               => undef,
    IncludeDir          => undef,
    MorePrivacy         => undef,
    NoticeAuth          => undef,
    OperCanUseMode      => undef,
    OperChanPAutoOp     => undef,
    OperServerMode      => undef,
    PAM                 => undef,
    PAMIsOptional       => undef,
    RequireAuthPing     => undef,
    ScrubCTCP           => undef,
    SyslogFacility      => undef,
    WebircPassword      => undef,
    },
    SSL                 => {
    CertFile            => undef,
    CipherList          => undef,
    CipherList          => undef,
    DHFile              => undef,
    KeyFile             => undef,
    KeyFilePassword     => undef,
    Ports               => undef,
    },
    Operator            => {
    Name                => undef,
    Password            => undef,
    Mask                => undef,
    },
    Server              => {
    Name                => undef,
    Host                => undef,
    Bind                => undef,
    Port                => undef,
    MyPassword          => undef,
    PeerPassword        => undef,
    Group               => undef,
    Passive             => undef,
    SSLConnect          => undef,
    ServiceMask         => undef,
    },
    Channel             => {
    Name                => undef,
    Topic               => undef,
    Modes               => undef,
    Key                 => undef,
    KeyFile             => undef,
    MaxUsers            => undef,
    },
  }
}
