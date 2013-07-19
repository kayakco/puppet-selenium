class { 'selenium::node':
  hub_host => 'test host',
  disable_screen_lock => true,
  enable_vnc => true,
  config => { 'nonsense' => 'huzzah' }
}
