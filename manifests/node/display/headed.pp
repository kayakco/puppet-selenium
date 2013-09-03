class selenium::node::display::headed(
  $autologin           = false,
  $disable_screen_lock = false,
  $enable_vnc          = $selenium::node::display::enable_vnc,
){

  if $::operatingsystem != 'Ubuntu' {
    fail('Headed display settings only support Ubuntu')
  }

  if $autologin {
    include selenium::node::display::headed::autologin
  }

  if $enable_vnc {
    include selenium::node::display::headed::vnc
  }
}
