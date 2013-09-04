define selenium::node::display::headless::xvfb_display(
  $display = $title,
  $height  = 768,
  $width   = 1280,
  $color   = '24+32',
  $vnc     = false,
){

  include selenium::node::display::headless::xvfb

  $command = template('selenium/xvfb_command.erb')

  bluepill::simple_app { "xvfb-${title}":
    start_command => $command,
    service_name  => "xvfb-${title}",
    rotate_logs   => true,
    require       => Package[$xvfb::package]
  }

  if $vnc {
    include selenium::node::display::headless::x11vnc

    $vnc_cmd = "x11vnc -forever -display :${display}"
    bluepill::simple_app { "x11vnc-${title}":
      start_command => $vnc_cmd,
      service_name  => "x11vnc-${title}",
      rotate_logs   => true,
    }
  }
}
