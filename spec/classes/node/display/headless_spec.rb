require 'spec_helper'

describe 'selenium::node::display::headless' do
  let :facts do
    { :operatingsystem => 'CentOS' }
  end

  let :params do
    {
      :enable_vnc => true,
      :display => '99',
      :width   => '100',
      :height  => '90',
      :color   => '24',
    }
  end

  it do
    should include_class('selenium::node::display::headless::xvfb')
    should contain_selenium__node__display__headless__xvfb_display('main').with({
      :display => '99',
      :width => '100',
      :height => '90',
      :color => '24',
      :vnc => true,
    })
  end
end
