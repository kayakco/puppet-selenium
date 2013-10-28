require 'spec_helper'

describe 'selenium::server' do
  context 'without java class' do
    let :pre_condition do
<<PRE
class selenium::common::jar {
 $path = '/s.jar'
}
PRE
end
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
class selenium::common::jar {
 $path = '/s.jar'
}
class myjava {
}
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
end
