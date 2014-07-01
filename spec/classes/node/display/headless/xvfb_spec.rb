require 'spec_helper'

describe 'selenium::node::display::headless::xvfb' do
  context 'Ubuntu' do
    let :facts do { :operatingsystem => 'Ubuntu' } end
    it do
      should contain_package('xvfb')
    end
  end

  context 'CentOS 6.3' do
    let :facts do 
      {
        :operatingsystem => 'CentOS',
        :operatingsystemrelease => '6.3',
      }
    end

    it do
      should contain_package('xorg-x11-server-Xvfb')
      should contain_package('libXfont').that_comes_before('Package[xorg-x11-server-Xvfb]')
    end
  end
end
