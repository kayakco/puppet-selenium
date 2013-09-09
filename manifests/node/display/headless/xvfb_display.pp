define selenium::node::display::headless::xvfb_display(
  $display       = $title,
  $height        = 768,
  $width         = 1280,
  $color         = '24+32',
  $vnc           = false,
  $vnc_password  = undef,
  $vnc_view_only = false,
){

  include selenium::conf
  include selenium::node::display::headless::xvfb

  $command = template('selenium/xvfb_command.erb')

  bluepill::simple_app { "xvfb-${title}":
    start_command => $command,
    service_name  => "xvfb-${title}",
    user          => $conf::user_name,
    group         => $conf::user_group,
    logfile       => "${conf::logdir}/xvfb-${title}",
    rotate_logs   => true,
    require       => Package[$xvfb::package]
  }

  if $vnc {
    include selenium::node::display::headless::x11vnc

    if $vnc_password {
      $pwfile   = "${conf::confdir}/x11vnc-${title}-password"
      $pwarg    = "-passwdfile ${pwfile}"

      file { $pwfile:
        owner   => $conf::user_name,
        group   => $conf::user_group,
        mode    => '0400',
        content => $vnc_password,
      }
    }else{
      $pwarg = ''
    }

    $viewarg = $vnc_view_only ? {
      true    => '-viewonly',
      default => '',
    }

    $vnc_cmd = "x11vnc -forever -display :${display} ${viewarg} ${pwarg}"
    bluepill::simple_app { "x11vnc-${title}":
      start_command => $vnc_cmd,
      service_name  => "x11vnc-${title}",
      user          => $conf::user_name,
      group         => $conf::user_group,
      logfile       => "${conf::logdir}/x11vnc-${title}",
      rotate_logs   => true,
    }
  }
}
