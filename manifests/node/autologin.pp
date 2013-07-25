class selenium::node::autologin {

  include selenium::conf

  package { 'lightdm':
    ensure => installed,
  }

  ini_setting { 'guest':
    setting => 'autologin-guest',
    value   => false,
  }

  ini_setting { 'user':
    setting => 'autologin-user',
    value   => $conf::user_name,
  }

  ini_setting { 'user-timeout':
    setting => 'autologin-user-timeout',
    value   => 0,
  }

  ini_setting { 'session':
    setting => 'autologin-session',
    value   => 'lightdm-autologin',
  }

  Ini_Setting['guest','user','user-timeout','session'] {
    ensure  => present,
    path    => '/etc/lightdm/lightdm.conf',
    section => 'SeatDefaults',
    require => Package['lightdm'],
  }

}
