class selenium(
  $hub_host,
){

  include selenium::node

  if member([$::fqdn,$::hostname],$hub_host){
    include selenium::hub
  }
}
