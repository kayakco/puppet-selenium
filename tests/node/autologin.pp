class selenium::conf {
  $user_name = 'nobody'
}
include selenium::conf
include selenium::node::autologin
