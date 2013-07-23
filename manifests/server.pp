define selenium::server(
  $env_vars          = {},     # Environment variables to set. (shellquoted)
  $system_properties = {},     # Hash of system properties to set for the jvm
  $java_args         = [],     # Array of arguments to pass to jvm
  $java_command      = 'java', # Java command to run
  $java_classname    = undef,  # Name of a Java class to require
  $selenium_args     = [],     # Array of arguments to pass to selenium jar
){

  include selenium::common
  include bluepill

  $appname = "selenium-${title}"
  $cmd     = template('selenium/start_command.erb')
  $logfile = "${conf::logdir}/${title}.log"
  $pidfile = "${conf::rundir}/${title}.pid"

  bluepill::app { $appname:
    content      => template('selenium/bluepill.conf.erb'),
    service_name => $appname,
    logfile      => $logfile,
    require      => [User[$conf::user_name],File[$conf::install_dir]],
  }

  if $java_classname == undef {
    warn('You should specify the name of the Java class you\'re using!')
  }else{
    include $java_classname
    Class[$java_classname] -> Bluepill::App["selenium-${title}"]
  }
}
