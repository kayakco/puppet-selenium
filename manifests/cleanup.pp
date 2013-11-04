class selenium::cleanup{
  include selenium::conf

  $script = "${conf::install_dir}/cleanup.sh"

  file { $script:
    ensure => file,
    owner  => $conf::user_name,
    group  => $conf::user_group,
    mode   => '0755',
    source => 'puppet:///modules/selenium/cleanup.sh',
  }
  ->
  cron { 'selenium-cleanup':
    command     => "${script} &>/tmp/selenium-cleanup.log",
    user        => $conf::user_name,
    environment => ['PATH=/bin:/usr/bin:/sbin:/usr/sbin'],
    hour        => 23,
    minute      => 0,
  }

}
