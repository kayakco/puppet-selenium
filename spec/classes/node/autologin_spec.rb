require 'spec_helper'

describe 'selenium::node::autologin' do
  let :pre_condition do
<<PP
class selenium::conf {
  $user_name = 'u'
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
      should contain_ini_setting(name).with(defaults.merge({
        :setting => "autologin-#{name}",
        :value   => val,
      }))
    end
  end
end
