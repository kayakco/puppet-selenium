# Single place to define default settings for node, hub, and regular.
class selenium::conf(
  $version        = '2.33.0',
  $manage_user    = true,
  $user_name      = 'selenium',
  $user_options   = {},
  $java_command   = 'java',
  $java_classname = undef,
  $install_dir    = '/usr/local/selenium',
){
  $user_group   = pick($user_options['group'],$user_name)
  $user_homedir = pick($user_options['homedir'],"/home/${user_name}")
  $confdir      = "${conf::install_dir}/conf"
  $rundir       = "${conf::install_dir}/run"
  $logdir       = "${conf::install_dir}/logs"
}
