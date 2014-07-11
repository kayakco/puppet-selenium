class selenium::common::jar {
  $path = '2'
}
include selenium::common::jar

$env_vars = { 'a' => 'b' }
$java_command = '/bin/java'
$java_args = '-Xmx512m'
$system_properties = { 'c' => 'd' }
$selenium_args = ['-role', 'hub']
$command = template('selenium/start_command.erb')

notify { "Start command: ${command}": }
