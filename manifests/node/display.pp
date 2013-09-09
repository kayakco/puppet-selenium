class selenium::node::display(
  $headless         = false,
  $enable_vnc       = false,
  $use_vnc_password = false,
  $vnc_password     = 'changeme',
  $vnc_view_only    = true,
){

  if $use_vnc_password {
    if $vnc_password == 'changeme' {
      fail('You must set the vnc_password!')
    }
  }

  if $headless {
    include selenium::node::display::headless
  } else {
    include selenium::node::display::headed
  }
}
