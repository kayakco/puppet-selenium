class selenium::hub(
  $java_args = [], # JVM args
  $system_properties = {}, # Java system properties
  $env_vars  = {}, # Environment variables
  $config    = {}, # Hub JSON configuration options.
){
  include selenium::common

  $configfile = "${conf::confdir}/hubConfig.json"
  file { $configfile:
    ensure  => present,
    owner   => $conf::user_name,
    group   => $conf::user_group,
    mode    => '0644',
    content => predictable_pretty_json($config)
  }

  selenium::server { 'hub':
    selenium_args     => ['-role','hub','-hubConfig',$configfile],
    java_command      => $conf::java_command,
    java_classname    => $conf::java_classname,
    java_args         => $java_args,
    system_properties => $system_properties,
    env_vars          => $env_vars,
    require           => Class['Selenium::Common'],
  }
}
