require 'spec_helper'

describe 'selenium::node' do
  let :facts do
    { :r9util_download_curl_version => '2',:operatingsystem => 'Ubuntu' }
  end
  let :pre_condition do
<<PP
class { 'selenium::conf':
  user_name => 'u',
  user_options => {'group' => 'g'},
  install_dir => '/i',
  java_command => '/tmp/j',
  java_classname => 'myjava',
}
class myjava {
}
PP
  end

  context 'do not enable extras' do
    let :params do
      {
        :hub_host => 'foo',
        :install_chromedriver => false,
        :system_properties => { 'q' => 'p' },
        :java_args => ['-Xmx800m'],
        :env_vars => {},
        :config_hash => { 'configuration' => {'bar' => 'a', 'foo' => 3 }},
      }
    end
    it do
      should_not contain_class('selenium::node::chromedriver')
      should contain_class('selenium::node::display')
      json = <<JSON
{
  "configuration": {
    "bar": "a",
    "foo": 3,
    "hub": "http://foo:4444/grid/register"
  }
}
JSON
      should contain_file('/i/conf/nodeConfig.json').with({
        :owner => 'u',
        :group => 'g',
        :mode => '0644',
        :content => json.chomp,
      })
      should contain_selenium__server('node').with({
        :java_command => '/tmp/j',
        :java_classname => 'myjava',
        :selenium_args => ['-role',
                           'node',
                           '-nodeConfig',
                           '/i/conf/nodeConfig.json'],
        :java_args => ['-Xmx800m'],
        :system_properties => {'q' => 'p'},
        :env_vars => {'DISPLAY' => ':0'},
      })
    end
  end

  context 'enable extras' do
    let :params do
      {
        :hub_host => 'foo',
        :install_chromedriver => true,
        :env_vars => { 'DISPLAY' => ':1' }
      }
    end
    it do
      should contain_class('selenium::node::display')
      should contain_class('selenium::node::chromedriver')
      should contain_selenium__server('node').with_env_vars({'DISPLAY' => ':1' })
    end
  end

  context 'set config_source' do
    let :params do
      {
        :hub_host => 'h',
        :config_source => 'aflag',
        :config_content => 'bflag',
        :config_hash => { 'c' => 'flag' }
      }
    end
    it do
      should contain_file('/i/conf/nodeConfig.json').with_source('aflag')
    end
  end

  context 'set config_content' do
    let :params do
      {
        :hub_host => 'h',
        :config_content => 'bflag',
        :config_hash => { 'c' => 'flag' }
      }
    end
    it do
      should contain_file('/i/conf/nodeConfig.json').with_content('bflag')
    end
  end

  context 'pass blupill_cfg_content' do
    let :params do { :bluepill_cfg_content => 'foo' } end
    it do
      should contain_selenium__server('node').with_bluepill_cfg_content('foo')
    end
  end

  context 'pass blupill_cfg_source' do
    let :params do { :bluepill_cfg_source => 'foo' } end
    it do
      should contain_selenium__server('node').with_bluepill_cfg_source('foo')
    end
  end

end
