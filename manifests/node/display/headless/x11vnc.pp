class selenium::node::display::headless::x11vnc{

  package { 'x11vnc': ensure => installed }

  if $::operatingsystem == 'CentOS' {
    include ::epel

    Package['x11vnc'] {
      require => Class['epel']
    }
  }

}
