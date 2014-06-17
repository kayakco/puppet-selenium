require 'spec_helper'

describe 'selenium::node::chromedriver' do
  before :all do
    @urlbase = 'http://chromedriver.storage.googleapis.com'
  end

  context '64bit arch' do
  let(:pre_condition) do
<<PP
class selenium::conf {
  $install_dir = '/s'
  $user_name = 'u'
  $user_group = 'g'
}
include selenium::conf
class selenium::node {
  $chromedriver_version = '2.4'
}
include selenium::node
PP
  end

    let :facts do
      { 
        :r9util_download_curl_version => '1',
        :architecture => 'amd64'
      }
    end

    it do
      zipfile = 'chromedriver_linux64.zip'
      should contain_r9util__download('download-driver').with({
        :url => File.join(@urlbase, '2.4', zipfile),
        :path => "/s/#{zipfile}",
      })
      should contain_file("/s/#{zipfile}").with({
        :owner => 'u',
        :group => 'g',
      })
      should contain_exec("unzip-/s/#{zipfile}").with({
        :command => "unzip -o #{zipfile}",
        :cwd     => '/s',
        :user    => 'u',
        :group   => 'g',
      })
      should contain_file('/s/chromedriver').with({
        :owner   => 'u',
        :group   => 'g',
        :mode    => '0755',
      })
      should contain_file('/usr/local/bin/chromedriver').with({
        :ensure  => 'link',
        :owner   => 'root',
        :group   => 'root',
        :target  => '/s/chromedriver',
      })
    end
  end

  context '32bit arch' do
    let :facts do
      {:r9util_download_curl_version => '1',
        :architecture => 'i586' }
    end
    let :params do
      {:version => '4.3'}
    end
    let(:pre_condition) do
<<PP
class selenium::conf {
  $install_dir = '/s'
}
include selenium::conf
PP
    end
    it do
      zipfile = 'chromedriver_linux32.zip'
      should contain_r9util__download('download-driver').with({
        :url => File.join(@urlbase, '4.3', zipfile),
        :path => "/s/#{zipfile}",
      })
      should contain_file("/s/#{zipfile}")
    end
  end
end
