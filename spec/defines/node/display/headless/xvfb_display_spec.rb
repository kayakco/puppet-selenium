require 'spec_helper'

describe 'selenium::node::display::headless::xvfb_display' do
  let :facts do
    { :operatingsystem => 'CentOS' }
  end

  context 'with vnc' do
    let :title do 'foo' end
    let :params do
      {
        :display => '99',
        :color => '23',
        :width => '10',
        :height => '20',
        :vnc => true,
      }
    end

    it do
      should include_class('selenium::node::display::headless::xvfb')
      should contain_bluepill__simple_app('xvfb-foo').with({
        :start_command => 'Xvfb :99 -nolisten tcp -fbdir /var/run -screen 0 10x20x23',
      })
      should include_class('selenium::node::display::headless::x11vnc')
      should contain_bluepill__simple_app('x11vnc-foo').with({
        :start_command => 'x11vnc -forever -display :99',
      })
    end
  end

  context 'no vnc' do
    let :title do 'foo' end
    let :params do { :vnc => false } end

    it do
      should_not include_class('selenium::node::display::headless::x11vnc')
      should_not contain_bluepill__simple_app('x11vnc-foo')
    end
  end
end
