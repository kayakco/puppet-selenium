class selenium::common{
  include selenium::conf
  include selenium::common::jar

  ensure_supported({'Ubuntu' => ['12']},true)

  if $conf::manage_user {
    include selenium::common::user
  }

  file { [$conf::install_dir,
          $conf::rundir,
          $conf::logdir,
          $conf::confdir]:
    ensure => directory,
    mode   => '0755',
    owner  => $conf::user_name,
    group  => $conf::user_group,
  }

}
