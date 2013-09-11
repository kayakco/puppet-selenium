require 'spec_helper'

describe 'selenium' do
  let :pre_condition do
    'class java{}'
  end
  let :facts do
    {
      :r9util_download_curl_version => '2',
      :operatingsystem              => 'Ubuntu',
      :hostname                     => 'derp',
      :fqdn                         => 'derp.com',
    }
  end

  context 'not the hub' do
    let :params do { :hub_host => 'foo' } end
    it do
      should include_class('selenium::node')
      should_not include_class('selenium::hub')
    end
  end

  context 'hostname matches hub setting' do
    let :params do { :hub_host => 'derp' } end
    it do
      should include_class('selenium::node')
      should include_class('selenium::hub')
    end
  end

  context 'fqdn matches hub setting' do
    let :params do { :hub_host => 'derp.com' } end
    it do
      should include_class('selenium::node')
      should include_class('selenium::hub')
    end
  end
end
