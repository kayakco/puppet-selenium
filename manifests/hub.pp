class selenium::hub(
  $java_args         = [], # JVM args
  $system_properties = {}, # Java system properties
  $env_vars          = {}, # Environment variables
  $config_hash       = {}, # Hub JSON configuration options.
  $config_source     = undef,
  $config_content    = undef,
  $bluepill_cfg_content = undef,
  $bluepill_cfg_source  = undef,
){
  include selenium::common

  $configfile = "${conf::confdir}/hubConfig.json"
  file { $configfile:
    ensure  => present,
    owner   => $conf::user_name,
    group   => $conf::user_group,
    mode    => '0644',
  }
  ->
  selenium::server { 'hub':
    selenium_args        => ['-role','hub','-hubConfig',$configfile],
    java_command         => $conf::java_command,
    java_classname       => $conf::java_classname,
    java_args            => $java_args,
    system_properties    => $system_properties,
    env_vars             => $env_vars,
    bluepill_cfg_content => $bluepill_cfg_content,
    bluepill_cfg_source  => $bluepill_cfg_source,
    subscribe            => File[$configfile],
    require              => Class['Selenium::Common'],
  }

  if $config_source != undef {
    File[$configfile]{
      source => $config_source,
    }
  } elsif $config_content != undef {
    File[$configfile]{
      content => $config_content,
    }
  } else {
    File[$configfile]{
      content => predictable_pretty_json($config_hash,true),
    }
  }
}
