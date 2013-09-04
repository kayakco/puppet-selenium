class selenium::node::display::headless::xvfb{

  $package_names = {
    'CentOS' => 'xorg-x11-server-Xvfb',
    'Ubuntu' => 'xvfb'
  }

  $xvfb = distro_lookup($package_names)

  package { 'xvfb':
    ensure => installed,
  }
}
