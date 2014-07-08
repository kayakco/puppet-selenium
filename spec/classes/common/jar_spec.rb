require 'spec_helper'

describe 'selenium::common::jar' do

  let(:pre_condition){
    "
class selenium::conf {
  $install_dir = '/mytestdir'
  $user_name   = 'u'
  $user_group  = 'g'
}
"
  }

  let(:url) do
    'http://selenium-release.storage.googleapis.com/' << 
    '31.4/selenium-server-standalone-31.4.3.jar'
  end

  let(:file) do '/mytestdir/selenium-server-standalone-31.4.3.jar' end
  let(:link) do '/mytestdir/selenium-server-standalone.jar' end

  context 'with custom version' do
    let :params do { :download_version => '31.4.3' } end

    it do
      should contain_class('selenium::conf')
      should contain_r9util__download(url).with({
        :path => file,
      })
      should contain_file(link).with({
        :owner  => 'u',
        :group  => 'g',
        :target => file,
      })
      should contain_file(file).with({
        :owner => 'u',
        :group => 'g',
        :mode  => '0644',
      })
    end
  end

  context 'without md5sum' do
    let :params do
      {
        :download_version => '31.4.3',
        :download_md5sum => 'abc'
      }
    end

    it do
      should contain_r9util__download(url).with({
        :path   => file,
        :md5sum => 'abc',
      })
    end
  end

  context 'with download=false but no custom_path parameter' do
    let :params do { :download => false } end

    it do
      expect {
        should contain_file(link)
      }.to raise_error(Puppet::Error, /custom_path/)
    end
  end

  context 'with custom_path parameter' do
    let :params do { :download => false, :custom_path => '/tmp/my.jar' } end

    it do
      should_not contain_r9util__download(url)
      should_not contain_file(file)
      should contain_file(link).with({
        :ensure => 'link',
        :target => '/tmp/my.jar',
      })
    end
  end

end
