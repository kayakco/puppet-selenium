class selenium::common::user{
  include selenium::conf

  $defaults = {
    'shell'      => '/bin/bash',
  }

  create_resources('r9util::system_user',
    { "${conf::user_name}" => $conf::user_options },
    $defaults)
}
