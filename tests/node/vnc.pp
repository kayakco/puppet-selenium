class selenium::node {
  $disable_screen_lock = false
  $vnc_password = 'frogs'
}
class selenium::conf {
  $user_homedir = '/tmp/testhomedir'
  $logdir = '/tmp/testlogdir'
}

exec { 'mk dirs':
  path => ['/bin','/usr/bin'],
  command => 'mkdir -p /tmp/testhomedir; mkdir -p /tmp/testlogdir',
}
->
class { 'selenium::conf': }
->
class { 'selenium::node': }
->
class { 'selenium::node::vnc': }
