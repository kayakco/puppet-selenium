require 'spec_helper'

describe 'selenium::common::user' do
  context 'let shell be overridden' do
    let :pre_condition do
      "
class selenium::conf{
    $user_options = { 'homedir' => '/var/run/selenium' }
    $user_name = 'foo'
}
"
    end

    it do
      should contain_r9util__system_user('foo').with({
        :homedir => '/var/run/selenium',
        :shell => '/bin/bash',
      })
    end
  end

  context 'let shell be overridden' do
    let :pre_condition do
      "
class selenium::conf{
    $user_options = { 'shell' => 'q' }
    $user_name = 'selenium'
}
"
    end
    it do
      should contain_r9util__system_user('selenium').with_shell('q')
    end
  end
end
