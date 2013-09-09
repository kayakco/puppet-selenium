require 'spec_helper'

describe 'selenium::node::display::headless::x11vnc' do
  context 'Ubuntu' do
    let :facts do { :operatingsystem => 'Ubuntu' } end
    it do
      should contain_package('x11vnc')
    end
  end

  context 'CentOS' do
    let :facts do { :operatingsystem => 'CentOS' } end
    it do
      should contain_package('x11vnc')
      should include_class('epel')
    end
  end
end
