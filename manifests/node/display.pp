class selenium::node::display(
  $headless   = false,
  $enable_vnc = false,
){
  if $headless {
    include selenium::node::display::headless
  } else {
    include selenium::node::display::headed
  }
}
