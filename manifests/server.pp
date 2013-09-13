define selenium::server(
  $env_vars          = {},     # Environment variables to set. (shellquoted)
  $system_properties = {},     # Hash of system properties to set for the jvm
  $java_args         = [],     # Array of arguments to pass to jvm
  $java_command      = 'java', # Java command to run
  $java_classname    = 'java', # Name of a Java class to require
  $selenium_args     = [],     # Array of arguments to pass to selenium jar
){

  include selenium::common
  include bluepill

  $appname = "selenium-${title}"
  $cmd     = template('selenium/start_command.erb')
  $logfile = "${conf::logdir}/${title}.log"
  $pidfile = "${conf::rundir}/${title}.pid"

  bluepill::simple_app { $appname:
    start_command     => $cmd,
    user              => $conf::user_name,
    group             => $conf::user_group,
    pidfile           => $pidfile,
    service_name      => $appname,
    logfile           => $logfile,
    logrotate_options => {
      'copytruncate' => true,
      'rotate'       => 2
    },
    require           => [User[$conf::user_name],File[$conf::install_dir]],
  }

  if $java_classname == 'UNDEFINED' {
    warning('Java classname set to UNDEFINED, not including or requiring Java')
  }else{
    include $java_classname
    Class[$java_classname] -> Bluepill::App["selenium-${title}"]
  }
}
