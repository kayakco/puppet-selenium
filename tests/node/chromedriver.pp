class selenium::conf {
  $user_name = 'choover'
  $user_group = 'choover'
  $install_dir = '/home/choover/se'
}
include selenium::conf
class { 'selenium::node::chromedriver':
  version => '2.1',
}
