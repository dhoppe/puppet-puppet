require 'spec_helper'

describe 'puppet::define', :type => :define do
  ['Debian'].each do |osfamily|
    let(:facts) {{
      :osfamily => osfamily,
    }}
    let(:pre_condition) { 'include puppet' }
    let(:title) { 'puppet.conf' }

    context "on #{osfamily}" do
      context 'when source file' do
        let(:params) {{
          :config_file_path   => '/etc/puppet/puppet.2nd.conf',
          :config_file_source => 'puppet:///modules/puppet/common/etc/puppet/puppet.conf',
        }}

        it do
          is_expected.to contain_file('define_puppet.conf').with(
            'ensure'  => 'present',
            'source'  => 'puppet:///modules/puppet/common/etc/puppet/puppet.conf',
            'notify'  => 'Service[puppet]',
            'require' => 'Package[puppet]',
          )
        end
      end

      context 'when content string' do
        let(:params) {{
          :config_file_path   => '/etc/puppet/puppet.3rd.conf',
          :config_file_string => '# THIS FILE IS MANAGED BY PUPPET',
        }}

        it do
          is_expected.to contain_file('define_puppet.conf').with(
            'ensure'  => 'present',
            'content' => /THIS FILE IS MANAGED BY PUPPET/,
            'notify'  => 'Service[puppet]',
            'require' => 'Package[puppet]',
          )
        end
      end

      context 'when content template' do
        let(:params) {{
          :config_file_path     => '/etc/puppet/puppet.4th.conf',
          :config_file_template => 'puppet/common/etc/puppet/puppet.conf.erb',
        }}

        it do
          is_expected.to contain_file('define_puppet.conf').with(
            'ensure'  => 'present',
            'content' => /THIS FILE IS MANAGED BY PUPPET/,
            'notify'  => 'Service[puppet]',
            'require' => 'Package[puppet]',
          )
        end
      end

      context 'when content template (custom)' do
        let(:params) {{
          :config_file_path         => '/etc/puppet/puppet.5th.conf',
          :config_file_template     => 'puppet/common/etc/puppet/puppet.conf.erb',
          :config_file_options_hash => {
            'key' => 'value',
          },
        }}

        it do
          is_expected.to contain_file('define_puppet.conf').with(
            'ensure'  => 'present',
            'content' => /THIS FILE IS MANAGED BY PUPPET/,
            'notify'  => 'Service[puppet]',
            'require' => 'Package[puppet]',
          )
        end
      end
    end
  end
end
