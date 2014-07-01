require 'spec_helper'

describe 'selenium::common' do
  let(:facts) do { :r9util_download_curl_version => '1' } end

  context 'mange_user is true' do
    let :pre_condition do
<<PP
      class { 'selenium::conf':
        install_dir => '/s',
        user_name   => 'foo',
        user_options => { 'group' => 'bar' }
      }
PP
    end

    it do
      should contain_class('selenium::conf')
      should contain_class('selenium::common::jar')
      should contain_class('selenium::common::user')
      ['/s',
       '/s/conf',
       '/s/logs',
       '/s/run'].each do |dir|
        should contain_file(dir).with({
          :ensure  => 'directory',
          :owner   => 'foo',
          :group   => 'bar',
          :recurse => true,
        })
      end
    end
  end

  context 'manage_user is false' do
    let :pre_condition do
<<PP
      class { 'selenium::conf':
        manage_user => false
      }
PP
    end

    it do
      should_not contain_class('selenium::common::user')
    end
  end
end
