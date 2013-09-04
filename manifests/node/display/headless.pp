class selenium::node::display::headless(
  $enable_vnc = $selenium::node::display::enable_vnc,
  $display    = 0,
  $width      = 768,
  $height     = 1024,
  $color      = '24+32',
){
  include selenium::node::display::headless::xvfb

  headless::xvfb_display { 'main':
    display => $display,
    width   => $width,
    height  => $height,
    color   => $color,
    vnc     => $enable_vnc,
  }
}
