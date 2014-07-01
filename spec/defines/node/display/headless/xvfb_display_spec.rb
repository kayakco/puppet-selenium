require 'spec_helper'

describe 'selenium::node::display::headless::xvfb_display' do
  let :facts do
    {
      :operatingsystem => 'CentOS',
      :operatingsystemrelease => '6.3',
    }
  end

  let :pre_condition do
    <<-PP
    class selenium::conf {
      $user_name  = 'u'
      $user_group = 'g'
      $confdir    = '/etc/se'
      $logdir     = '/l'
      $rundir     = '/r'
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
      should contain_class('selenium::node::display::headless::xvfb')
      should contain_bluepill__simple_app('xvfb-foo').with({
        :user    => 'u',
        :group   => 'g',
        :logfile => '/l/xvfb-foo',
        :pidfile => '/r/xvfb-foo.pid',
        :start_command => 'Xvfb :99 -nolisten tcp -fbdir /r/xvfb -screen 0 10x20x23',
      })
      should contain_class('selenium::node::display::headless::x11vnc')
      should contain_bluepill__simple_app('x11vnc-foo').with({
        :user    => 'u',
        :group   => 'g',
        :logfile => '/l/x11vnc-foo',
        :pidfile => '/r/x11vnc-foo.pid',
        :start_command => 'x11vnc -forever -display :99 -rfbport 5900  ',
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

  context 'with vnc (non-standard port)' do
    let :title do 'foo' end
    let :params do
      {:vnc => true,:vnc_port => 5908}
    end

    it do
      should contain_bluepill__simple_app('x11vnc-foo').with({
        :start_command => /\-rfbport 5908\s/,
      })
    end

  end

  context 'no vnc' do
    let :title do 'foo' end
    let :params do { :vnc => false } end

    it do
      should_not contain_class('selenium::node::display::headless::x11vnc')
      should_not contain_bluepill__simple_app('x11vnc-foo')
    end
  end
end
