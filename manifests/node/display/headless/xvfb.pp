class selenium::node::display::headless::xvfb{

  include selenium::conf

  $package_names = {
    'CentOS' => 'xorg-x11-server-Xvfb',
    'Ubuntu' => 'xvfb'
  }

  $package = distro_lookup($package_names)

  package { $package:
    ensure => installed,
  }

  if $::operatingsystem == 'CentOS' {
    package { 'libXfont': } -> Package[$package]
  }

  $fbdir = "${conf::rundir}/xvfb"

  file { "${conf::rundir}/xvfb":
    ensure => directory,
    owner  => $conf::user_name,
    group  => $conf::user_group,
    mode   => '0755',
  }
}
