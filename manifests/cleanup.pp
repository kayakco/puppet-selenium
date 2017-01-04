class selenium::cleanup(
  $minutes_old = 180,
){
  include selenium::conf

  $script = "${conf::install_dir}/cleanup.sh"
  $logfile = "${conf::logdir}/cleanup.log"

  if "${minutes_old}" !~ /\A\d+\z/ {
    fail("\$minutes_old parameter must be an integer, got: \"${minutes_old}\"")
  }

  file { $script:
    ensure => file,
    owner  => $conf::user_name,
    group  => $conf::user_group,
    mode   => '0755',
    source => 'puppet:///modules/selenium/cleanup.sh',
  }
  ->
  cron { 'selenium-cleanup':
    command     => "${script} ${minutes_old} &> ${logfile}",
    user        => $conf::user_name,
    environment => ['PATH=/bin:/usr/bin:/sbin:/usr/sbin'],
    hour        => '*',
    minute      => 0,
  }

}
