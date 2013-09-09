class selenium::node::display::headed(
  $autologin           = false,
  $disable_screen_lock = false,
  $enable_vnc          = $selenium::node::display::enable_vnc,
  $vnc_password        = $selenium::node::display::vnc_password,
  $use_vnc_password    = $selenium::node::display::use_vnc_password,
  $vnc_view_only       = $selenium::node::display::vnc_view_only,
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
