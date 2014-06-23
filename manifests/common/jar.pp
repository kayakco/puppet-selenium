# Installs selenium server standalone jar
class selenium::common::jar(
  $md5sum = undef,
){
  include selenium::conf

  $version  = $conf::version
  $filename = "selenium-server-standalone-${version}.jar"
  $host     = 'http://selenium-release.storage.googleapis.com'

  $templ = '<%= @version.split(".").first(2) * "." %>'
  $major_minor_version = inline_template($templ)

  $jar_url = "${host}/${major_minor_version}/${filename}"
  $path    = "${conf::install_dir}/${filename}"

  r9util::download { $jar_url:
    path    => $path,
    md5sum  => $md5sum,
    require => File[$conf::install_dir]
  }
  ->
  file { $path:
    owner => $conf::user_name,
    group => $conf::user_group,
    mode  => '0644',
  }

}
