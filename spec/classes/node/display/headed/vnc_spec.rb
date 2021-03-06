require 'spec_helper'

describe 'selenium::node::display::headed::vnc' do
  CONF_PC = <<PP
  class selenium::conf{
    $user_homedir = '/s'
    $user_name = 'u'
    $user_group = 'g'
    $logdir = '/s/logs'
  }
PP

  context 'do not disable screenlock, no password, view-only, port undef' do
    let(:pre_condition) do
<<PP
#{CONF_PC}

  class selenium::node::display::headed {
    $disable_screen_lock = false
    $use_vnc_password    = false
    $vnc_password        = 'foobar'
    $vnc_view_only       = true
  }
  include selenium::node::display::headed
PP
    end
    it do
      file_defaults = {
        :owner => 'u',
        :group => 'g',
      }
      should contain_package('gnome-user-share')

      ['/s/.config','/s/.config/autostart'].each do |dir|
        should contain_file(dir).with(file_defaults.merge({
          :ensure => 'directory',
          :mode => '0700',
        }))
      end

      should contain_file('/s/onlogin').with(file_defaults.merge({
        :ensure => 'file',
        :mode => '0755',
        :content => /Not setting VNC port.*Not setting a VNC password.*Making VNC server view\-only.*Not disabling screen lock/m
      }))

      should contain_file('/s/.config/autostart/onlogin.desktop').with(file_defaults.merge({
        :ensure => 'file',
        :mode => '0644',
        :content => /Exec=\/s\/onlogin$/
      }))
    end
  end

  context 'disable screenlock' do
    let(:pre_condition) do
<<PP
#{CONF_PC}

  class selenium::node::display::headed {
    $disable_screen_lock = true
    $use_vnc_password    = false
    $vnc_password        = 'foobar'
    $vnc_view_only       = true
  }
  include selenium::node::display::headed
PP
    end
    it do
      should contain_file('/s/onlogin').with_content(/Disabling screen lock/)
    end
  end

  context 'not view_only' do
    let(:pre_condition) do
<<PP
#{CONF_PC}

  class selenium::node::display::headed {
    $disable_screen_lock = false
    $use_vnc_password    = false
    $vnc_password        = 'foobar'
    $vnc_view_only       = false
  }
  include selenium::node::display::headed
PP
    end
    it do
      should contain_file('/s/onlogin').with_content(/Not making VNC server view\-only/)
    end
  end


  context 'with password' do
    let(:pre_condition) do
<<PP
#{CONF_PC}

  class selenium::node::display::headed {
    $disable_screen_lock = false
    $use_vnc_password    = true
    $vnc_password        = 'foobar'
    $vnc_view_only       = true
  }
  include selenium::node::display::headed
PP
    end
    it do
      should contain_file('/s/onlogin').with_content(/Setting vnc password.*vnc\-password "Zm9vYmFy"\s/m)
    end
  end


  context 'with port specified' do
    let(:pre_condition) do
<<PP
#{CONF_PC}

  class selenium::node::display::headed {
    $disable_screen_lock = false
    $use_vnc_password    = false
    $vnc_port            = 5943
  }
  include selenium::node::display::headed
PP
    end
    it do
      should contain_file('/s/onlogin').with_content(/"Using VNC port 5943"/)
    end
  end

end
