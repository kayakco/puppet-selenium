class selenium::node::display::headed::vnc{

  include selenium::conf

  $disable_screen_lock = $headed::disable_screen_lock
  $home                = $conf::user_homedir
  $logdir              = $conf::logdir
  $onlogin_script      = "${home}/onlogin"

  package { 'gnome-user-share':
    ensure => installed,
  }

  file { $onlogin_script:
    ensure  => file,
    mode    => '0755',
    content => template('selenium/onlogin.erb')
  }

  file { ["${home}/.config",
          "${home}/.config/autostart"]:
    ensure  => directory,
    mode    => '0700',
  }

  file { "${home}/.config/autostart/onlogin.desktop":
    ensure  => file,
    mode    => '0644',
    content => template('selenium/onlogin.desktop.erb'),
  }

  File [$onlogin_script,
        "${home}/.config",
        "${home}/.config/autostart",
        "${home}/.config/autostart/onlogin.desktop"]{
    owner => $conf::user_name,
    group => $conf::user_group
  }
}
