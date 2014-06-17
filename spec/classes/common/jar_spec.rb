require 'spec_helper'

describe 'selenium::common::jar' do
  let(:pre_condition){
    "
class selenium::conf {
  $version = '31.4.3'
  $install_dir = '/mytestdir'
  $user_name = 'u'
  $user_group = 'g'
}
"
  }
  let(:facts) do { :r9util_download_curl_version => '1' } end

  it do
    should include_class('selenium::conf')
    url = 'http://selenium-release.storage.googleapis.com/31.4/selenium-server-standalone-31.4.3.jar'
    file = '/mytestdir/selenium-server-standalone-31.4.3.jar'
    should contain_r9util__download(url).with_path(file)
    should contain_file(file).with({
      :owner => 'u',
      :group => 'g',
      :mode  => '0644',
    })
  end
end
