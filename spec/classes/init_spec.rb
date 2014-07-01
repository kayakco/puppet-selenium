require 'spec_helper'

describe 'selenium' do
  let :pre_condition do
    'class java{}'
  end
  let :facts do
    {
      :operatingsystem              => 'Ubuntu',
      :hostname                     => 'derp',
      :fqdn                         => 'derp.com',
    }
  end

  context 'not the hub' do
    let :params do { :hub_host => 'foo' } end
    it do
      should contain_class('selenium::node')
      should_not contain_class('selenium::hub')
    end
  end

  context 'hostname matches hub setting' do
    let :params do { :hub_host => 'derp' } end
    it do
      should contain_class('selenium::node')
      should contain_class('selenium::hub')
    end
  end

  context 'fqdn matches hub setting' do
    let :params do { :hub_host => 'derp.com' } end
    it do
      should contain_class('selenium::node')
      should contain_class('selenium::hub')
    end
  end
end
