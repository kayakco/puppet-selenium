require 'spec_helper'

describe 'selenium::node::vnc' do
  CONF_PC = <<PP
  class selenium::conf{
    $user_homedir = '/s'
    $user_name = 'u'
    $user_group = 'g'
    $logdir = '/s/logs'
  }
PP

  context 'do not disable screenlock' do
    let(:pre_condition) do
<<PP
#{CONF_PC}

  class selenium::node {
    $disable_screen_lock = false
  }
  include selenium::node
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
        :content => /Not disabling screen lock/m
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

  class selenium::node {
    $disable_screen_lock = true
  }
  include selenium::node
PP
    end
    it do
      should contain_file('/s/onlogin').with_content(/Disabling screen lock/)
    end
  end

end
