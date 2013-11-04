require 'spec_helper'

describe 'selenium::server' do
  STUB_JAR = <<EOF
class selenium::common::jar {
  $path = '/s.jar'
}
EOF
  STUB_JAVA = "class myjava{}"

  context 'without java class' do
    let :pre_condition do STUB_JAR end

    let :title do 'foo' end
    let :params do { :java_classname => 'UNDEFINED' } end

    it 'should warn about java class' do
      should contain_bluepill__app('selenium-foo')
      should_not include_class('java')
    end
  end

  context 'with java class' do
    let :pre_condition do
<<PP
class selenium::conf {
 $install_dir = '/i'
 $user_name = 'u'
 $user_group = 'g'
 $logdir = '/l'
 $rundir = '/r'
}
#{STUB_JAR}
#{STUB_JAVA}
PP
    end

    let :title do 'foo' end
    let :params do
      {
        :env_vars => { 'e2' => '2 e' },
        :java_args => ['-Xmx800m'],
        :system_properties => {'p.q' => 'r'},
        :java_command => '/tmp/the java',
        :java_classname => 'myjava',
        :selenium_args => ['a','b','c']
      }
    end

    it do
      should include_class('myjava')
      start_command = <<CMD
/usr/bin/env e2=2\\ e /tmp/the\\ java -Xmx800m \
-Dp.q=r -jar /s.jar a b c
CMD
      should contain_bluepill__simple_app('selenium-foo').with({
        :service_name => 'selenium-foo',
        :logfile      => '/l/foo.log',
        :rotate_logs  => true,
        :logrotate_options => { 'copytruncate' => true, 'rotate' => '2' },
        :user         => 'u',
        :group        => 'g',
        :pidfile      => '/r/foo.pid',
      })
    end
  end

  context 'pass blupill_cfg_content' do
    let :params do
      { :bluepill_cfg_content => 'foo', :java_classname => 'myjava' }
    end
    let :pre_condition do "#{STUB_JAVA}\n#{STUB_JAR}" end
    let :title do 'derp' end
    it do
      should contain_bluepill__simple_app('selenium-derp').with_config_content('foo')
    end
  end

  context 'pass blupill_cfg_source' do
    let :params do
      { :bluepill_cfg_source => 'foo', :java_classname => 'myjava' }
    end
    let :pre_condition do "#{STUB_JAVA}\n#{STUB_JAR}" end
    let :title do 'derp' end

    it do
      should contain_bluepill__simple_app('selenium-derp').with_config_source('foo')
    end
  end

end
