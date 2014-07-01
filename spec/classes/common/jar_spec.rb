require 'spec_helper'

describe 'selenium::common::jar' do

  let(:pre_condition){
    "
class selenium::conf {
  $version     = '31.4.3'
  $install_dir = '/mytestdir'
  $user_name   = 'u'
  $user_group  = 'g'
}
"
  }

  let(:facts) do { :r9util_download_curl_version => '1' } end

  let(:url) do
    'http://selenium-release.storage.googleapis.com/' << 
    '31.4/selenium-server-standalone-31.4.3.jar'
  end

  let(:file) do '/mytestdir/selenium-server-standalone-31.4.3.jar' end

  context 'with defaults' do
    it do
      should contain_class('selenium::conf')
      should contain_r9util__download(url).with({
        :path => file,
      })
      should contain_file(file).with({
        :owner => 'u',
        :group => 'g',
        :mode  => '0644',
      })
    end
  end

  context 'with md5sum' do
    let :params do { :md5sum => 'abc' } end
    it do
      should contain_r9util__download(url).with({
        :path   => file,
        :md5sum => 'abc',
      })
    end
  end

  context 'with source parameter' do
    let :params do { :source => 'puppet:///myselenium.jar' } end

    it do
      should_not contain_r9util__download(url)
      should contain_file(file).with({
        :path   => file,
        :source => 'puppet:///myselenium.jar'
      })
    end
  end
end
