class selenium::node(
  $hub_host,
  $hub_port = '4444',

  $java_args     = [],
  $system_properties = {},
  $env_vars      = {},

  $disable_screen_lock  = false,
  $autologin            = false,
  $enable_vnc           = false,
  $vnc_password         = undef,

  $install_chromedriver = false,
  $chromedriver_version = '2.1',

  $config               = {}, # JSON configuration options
){
  include selenium::common

  $hub = "http://${hub_host}:${hub_port}/grid/register"
  $config_defaults = {
    'hub' => $hub,
  }

  $configfile = "${conf::confdir}/nodeConfig.json"
  file { $configfile:
    ensure  => present,
    owner   => $conf::user_name,
    group   => $conf::user_group,
    mode    => '0644',
    content => predictable_pretty_json(merge($config_defaults,$config))
  }

  selenium::server { 'node':
    selenium_args     => ['-role','node','-nodeConfig',$configfile],
    java_command      => $conf::java_command,
    java_classname    => $conf::java_classname,
    java_args         => $java_args,
    system_properties => $system_properties,
    env_vars          => merge({ 'DISPLAY' => ':0' }, $env_vars ),
    require           => Class['Selenium::Common']
  }

  if $install_chromedriver {
    include selenium::node::chromedriver
  }
  if $autologin {
    include selenium::node::autologin
  }
  if $enable_vnc {
    include selenium::node::vnc
  }
}
