require 'spec_helper'

describe 'selenium::node::display::headed' do
  let :facts do
    {:operatingsystem => 'Ubuntu'}
  end

  context 'Ubuntu - autologin and vnc' do
    let :params do
      { :autologin => true, :enable_vnc => true }
    end
    it do
      should contain_class('selenium::node::display::headed::vnc')
      should contain_class('selenium::node::display::headed::autologin')
    end
  end

  context 'Ubuntu - no autologin' do
    let :params do
      { :autologin => false, :enable_vnc => true }
    end
    it do
      should contain_class('selenium::node::display::headed::vnc')
      should_not contain_class('selenium::node::display::headed::autologin')
    end
  end

  context 'Ubuntu - no vnc' do
    let :params do
      { :autologin => true, :enable_vnc => false }
    end
    it do
      should_not contain_class('selenium::node::display::headed::vnc')
      should contain_class('selenium::node::display::headed::autologin')
    end
  end

  context 'Not Ubuntu' do
    let :facts do
      {
        :operatingsystem => 'CentOS',
        :operatingsystemrelease => '6.3',
      }
    end

    it do
      expect {
        should contain_class('selenium::node::display::headed::vnc')
      }.to raise_error(Puppet::Error,/only support Ubuntu/)
    end
  end
end
