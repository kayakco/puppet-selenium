class selenium::node::chromedriver(
  $version = $selenium::node::chromedriver_version,
){

  $arch = $::architecture ? {
    'amd64'  => '64',
    'x86_64' => '64',
    default  => '32',
  }

  $filename = "chromedriver_linux${arch}_${version}.zip"
  $zippath  = "${conf::install_dir}/${filename}"
  $path     = "${conf::install_dir}/chromedriver"

  r9util::download { 'download-driver':
    url    => "http://chromedriver.googlecode.com/files/${filename}",
    path   => $zippath,
    before => File[$path],
  }
  ->
  file { $zippath:
    owner  => $conf::user_name,
    group  => $conf::user_group,
  }
  ->
  exec { "unzip-${zippath}":
    command     => "unzip -o ${filename}",
    path        => ['/bin','/usr/bin'],
    cwd         => $conf::install_dir,
    user        => $conf::user_name,
    group       => $conf::user_group,
    subscribe   => R9Util::Download['download-driver'],
    refreshonly => true,
  }
  ->
  file { $path:
    owner => $conf::user_name,
    group => $conf::user_group,
    mode  => '0755',
  }
  ->
  file { '/usr/local/bin/chromedriver':
    ensure => link,
    owner  => 'root',
    group  => 'root',
    target => $path,
  }
}
