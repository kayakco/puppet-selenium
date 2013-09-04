require 'spec_helper'

describe 'selenium::node::display::headless::xvfb' do
  context 'Ubuntu' do
    let :facts do { :operatingsystem => 'Ubuntu' } end
    it do
      should contain_package('xvfb')
    end
  end

  context 'CentOS' do
    let :facts do { :operatingsystem => 'CentOS' } end
    it do
      should contain_package('xorg-x11-server-Xvfb')
    end
  end
end
