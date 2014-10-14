class selenium(
  $hub_host,
){

  if member([$::fqdn, $::hostname], $hub_host){
    include selenium::hub
  } else {
    include selenium::node
  }
}
