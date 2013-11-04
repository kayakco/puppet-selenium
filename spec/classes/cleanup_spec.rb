require 'spec_helper'

describe 'selenium::cleanup' do
  let :pre_condition do
<<PRE
class selenium::conf{
  $user_name = 'foo'
  $user_group = 'bar'
  $install_dir = '/i'
}
PRE
  end

  it do
    should contain_file('/i/cleanup.sh').with({
      :owner  => 'foo',
      :group  => 'bar',
      :mode   => '0755',
      :source => 'puppet:///modules/selenium/cleanup.sh',
    })
    should contain_cron('selenium-cleanup').with({
      :command => '/i/cleanup.sh',
      :user    => 'foo',
    })
  end
end
