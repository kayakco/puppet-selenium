require 'spec_helper'

describe 'selenium::node::display' do
  let :facts do
    {:operatingsystem => 'Ubuntu'}
  end

  context 'headless' do
    let :params do
      { 'headless' => true }
    end

    it do
      expect {
        should include_class('selenium::node::display::headless')
        should_not include_class('selenium::node::display::headed')
      }.to raise_error(Puppet::Error,/not yet implemented/)
    end
  end

  context 'headed' do
    let :params do
      { 'headless' => false }
    end

    it do
      should include_class('selenium::node::display::headed')
      should_not include_class('selenium::node::display::headless')
    end

  end
end
