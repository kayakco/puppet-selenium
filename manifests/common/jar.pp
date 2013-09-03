# Installs selenium server standalone jar
class selenium::common::jar{
  include selenium::conf

  $filename = "selenium-server-standalone-${conf::version}.jar"
  $jar_url = "http://selenium.googlecode.com/files/${filename}"

  $path = "${conf::install_dir}/${filename}"

  r9util::download { $jar_url:
    path    => $path,
    require => File[$conf::install_dir]
  }
  ->
  file { $path:
    owner => $conf::user_name,
    group => $conf::user_group,
    mode  => '0644',
  }

}
