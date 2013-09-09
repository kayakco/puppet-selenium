require 'spec_helper'

describe 'selenium::node::display::headless::xvfb_display' do
  let :facts do
    { :operatingsystem => 'CentOS' }
  end
  let :pre_condition do
    <<-PP
    class selenium::conf {
      $user_name  = 'u'
      $user_group = 'g'
      $confdir    = '/etc/se'
      $logdir     = '/l'
    }
    PP
  end

  context 'with vnc (no password, not view only)' do
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
        :user    => 'u',
        :group   => 'g',
        :logfile => '/l/xvfb-foo',
        :start_command => 'Xvfb :99 -nolisten tcp -fbdir /var/run -screen 0 10x20x23',
      })
      should include_class('selenium::node::display::headless::x11vnc')
      should contain_bluepill__simple_app('x11vnc-foo').with({
        :user    => 'u',
        :group   => 'g',
        :logfile => '/l/x11vnc-foo',
        :start_command => 'x11vnc -forever -display :99  ',
      })
    end
  end

  context 'with vnc (view only)' do
    let :title do 'foo' end
    let :params do
      {:vnc => true,:vnc_view_only => true}
    end

    it do
      should contain_bluepill__simple_app('x11vnc-foo').with({
        :start_command => /\-viewonly/,
      })
    end
  end

  context 'with vnc (with password)' do
    let :title do 'foo' end
    let :params do
      {:vnc => true,:vnc_password => 'foobar'}
    end

    it do
      pwfile = '/etc/se/x11vnc-foo-password'
      should contain_bluepill__simple_app('x11vnc-foo').with({
        :start_command => /\-passwdfile #{Regexp.escape(pwfile)}(\s|\z)/,
      })
      should contain_file(pwfile).with({
        :owner   => 'u',
        :group   => 'g',
        :mode    => '0400',
        :content => 'foobar',
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
