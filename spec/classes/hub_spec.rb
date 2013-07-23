require 'spec_helper'

describe 'selenium::hub' do
  let :facts do
    { :r9util_download_curl_version => '2' }
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
  let :params do
    {
      :system_properties => { 'q' => 'p' },
      :java_args => ['-Xmx800m'],
      :env_vars => { 'foo' => '1' },
      :config_hash => { 'bar' => 'a', 'foo' => 3 },
    }
  end
  it do
    json = <<CONTENT
{
  "bar": "a",
  "foo": 3
}
CONTENT
    should contain_file('/i/conf/hubConfig.json').with({
      :owner => 'u',
      :group => 'g',
      :mode  => '0644',
      :content => json.chomp
    })
    should contain_selenium__server('hub').with({
      :selenium_args => ['-role','hub','-hubConfig','/i/conf/hubConfig.json'],
      :java_command => '/tmp/j',
      :java_classname => 'myjava',
      :java_args => ['-Xmx800m'],
      :system_properties => {'q' => 'p'},
      :env_vars => {'foo' => '1'},
    })
  end

  context 'set config_source' do
    let :params do
      {
        :config_source => 'aflag',
        :config_content => 'bflag',
        :config_hash => { 'c' => 'flag' }
      }
    end
    it do
      should contain_file('/i/conf/hubConfig.json').with_source('aflag')
    end
  end

  context 'set config_content' do
    let :params do
      {
        :config_content => 'bflag',
        :config_hash => { 'c' => 'flag' }
      }
    end
    it do
      should contain_file('/i/conf/hubConfig.json').with_content('bflag')
    end
  end

end
