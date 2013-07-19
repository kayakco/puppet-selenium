# == Class: selenium
#
# Full description of class selenium here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { selenium:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#


class selenium(
  $version = '2.33.0',
  # Environment variables
  $env_vars = {},
  # Java crap
  $jvmargs = {},
  $java_command = {},
  $java_class = undef,
  $manage_user = true,
  $user_name = 'selenium',
  $user_options = {},
  $is_node = true,
  $node_options = {
  },
  $is_hub  = false,
){
  # We will: create a user selenium
  #          with a home dir of /usr/local/selenium
  #          and a conf dir of $home/conf
  #          and a downloaded jar of $home/selenium-server-standalone.jar
  #          and a startup command
  #          and hub/node json configs rendered in $conf/hubConfig.json
  #                                                $conf/nodeConfig.json
  #
  # I could have any number of server processes.
  # define selenium::server{ 'hub':
  #   env_vars => {}, # a bunch of environment variables to set.
  #   jvmargs => '',  # array or string of arguments that go before.
  #   system_properties => {}, # hash of system properties to set in the jvm
  #   java_command => 'java',  # java command to run
  #   java_classname => undef #'java',
  #   args => '', # string or array of program arguments
  # }

  # The major problem I have to figure out right is -- I need common
  # settings that should be shared between the two classes. It is dumb to have to specify java_command twice.
  #
  #
  # include selenium::node(
  # ){
  # }
  #
  warn('Please use the selenium::hub or selenium::node class')
  include selenium::node
}
