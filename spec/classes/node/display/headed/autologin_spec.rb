require 'spec_helper'

describe 'selenium::node::display::headed::autologin' do
  let :pre_condition do
<<PP
class selenium::conf {
  $user_name = 'u'
  $user_options = {}
}
PP
  end
  it do
    defaults = {
      :ensure => 'present',
      :path   => '/etc/lightdm/lightdm.conf',
      :section => 'SeatDefaults'
    }

    {
      'guest' => false,
      'user' => 'u',
      'user-timeout' => 0,
      'session' => 'lightdm-autologin'
    }.each_pair do |name,val|
      expected = defaults.merge(
        :setting => "autologin-#{name}",
        :value => val
      )
      should contain_ini_setting(name).with(expected)
      should contain_package('lightdm')
      should contain_exec('add-selenium-user-to-nopasswdlogin-group').with_command('adduser u nopasswdlogin')
    end
  end
end
