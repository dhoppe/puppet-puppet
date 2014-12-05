require 'spec_helper'

describe 'puppet', :type => :class do
  ['Debian'].each do |osfamily|
    let(:facts) {{
      :osfamily => osfamily,
    }}

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_anchor('puppet::begin') }
    it { is_expected.to contain_class('puppet::params') }
    it { is_expected.to contain_class('puppet::install') }
    it { is_expected.to contain_class('puppet::config') }
    it { is_expected.to contain_class('puppet::service') }
    it { is_expected.to contain_anchor('puppet::end') }

    context "on #{osfamily}" do
      describe 'puppet::install' do
        context 'defaults' do
          it do
            is_expected.to contain_package('puppet').with({
              'ensure' => 'present',
            })
          end
        end

        context 'when package latest' do
          let(:params) {{
            :package_ensure => 'latest',
          }}

          it do
            is_expected.to contain_package('puppet').with({
              'ensure' => 'latest',
            })
          end
        end

        context 'when package absent' do
          let(:params) {{
            :package_ensure => 'absent',
            :service_ensure => 'stopped',
            :service_enable => false,
          }}

          it do
            is_expected.to contain_package('puppet').with({
              'ensure' => 'absent',
            })
          end
          it do
            is_expected.to contain_file('puppet.conf').with({
              'ensure'  => 'present',
              'notify'  => 'Service[puppet]',
              'require' => 'Package[puppet]',
            })
          end
          it do
            is_expected.to contain_service('puppet').with({
              'ensure' => 'stopped',
              'enable' => false,
            })
          end
        end

        context 'when package purged' do
          let(:params) {{
            :package_ensure => 'purged',
            :service_ensure => 'stopped',
            :service_enable => false,
          }}

          it do
            is_expected.to contain_package('puppet').with({
              'ensure' => 'purged',
            })
          end
          it do
            is_expected.to contain_file('puppet.conf').with({
              'ensure'  => 'absent',
              'notify'  => 'Service[puppet]',
              'require' => 'Package[puppet]',
            })
          end
          it do
            is_expected.to contain_service('puppet').with({
              'ensure' => 'stopped',
              'enable' => false,
            })
          end
        end
      end

      describe 'puppet::config' do
        context 'defaults' do
          it do
            is_expected.to contain_file('puppet.conf').with({
              'ensure'  => 'present',
              'notify'  => 'Service[puppet]',
              'require' => 'Package[puppet]',
            })
          end
        end

        context 'when source dir' do
          let(:params) {{
            :config_dir_source => 'puppet:///modules/puppet/common/etc/puppet',
          }}

          it do
            is_expected.to contain_file('puppet.dir').with({
              'ensure'  => 'directory',
              'force'   => false,
              'purge'   => false,
              'recurse' => true,
              'source'  => 'puppet:///modules/puppet/common/etc/puppet',
              'notify'  => 'Service[puppet]',
              'require' => 'Package[puppet]',
            })
          end
        end

        context 'when source dir purged' do
          let(:params) {{
            :config_dir_purge  => true,
            :config_dir_source => 'puppet:///modules/puppet/common/etc/puppet',
          }}

          it do
            is_expected.to contain_file('puppet.dir').with({
              'ensure'  => 'directory',
              'force'   => true,
              'purge'   => true,
              'recurse' => true,
              'source'  => 'puppet:///modules/puppet/common/etc/puppet',
              'notify'  => 'Service[puppet]',
              'require' => 'Package[puppet]',
            })
          end
        end

        context 'when source file' do
          let(:params) {{
            :config_file_source => 'puppet:///modules/puppet/common/etc/puppet/puppet.conf',
          }}

          it do
            is_expected.to contain_file('puppet.conf').with({
              'ensure'  => 'present',
              'source'  => 'puppet:///modules/puppet/common/etc/puppet/puppet.conf',
              'notify'  => 'Service[puppet]',
              'require' => 'Package[puppet]',
            })
          end
        end

        context 'when content string' do
          let(:params) {{
            :config_file_string => '# THIS FILE IS MANAGED BY PUPPET',
          }}

          it do
            is_expected.to contain_file('puppet.conf').with({
              'ensure'  => 'present',
              'content' => /THIS FILE IS MANAGED BY PUPPET/,
              'notify'  => 'Service[puppet]',
              'require' => 'Package[puppet]',
            })
          end
        end

        context 'when content template' do
          let(:params) {{
            :config_file_template => 'puppet/common/etc/puppet/puppet.conf.erb',
          }}

          it do
            is_expected.to contain_file('puppet.conf').with({
              'ensure'  => 'present',
              'content' => /THIS FILE IS MANAGED BY PUPPET/,
              'notify'  => 'Service[puppet]',
              'require' => 'Package[puppet]',
            })
          end
        end

        context 'when content template (custom)' do
          let(:params) {{
            :config_file_template     => 'puppet/common/etc/puppet/puppet.conf.erb',
            :config_file_options_hash => {
              'key' => 'value',
            },
          }}

          it do
            is_expected.to contain_file('puppet.conf').with({
              'ensure'  => 'present',
              'content' => /THIS FILE IS MANAGED BY PUPPET/,
              'notify'  => 'Service[puppet]',
              'require' => 'Package[puppet]',
            })
          end
        end
      end

      describe 'puppet::service' do
        context 'defaults' do
          it do
            is_expected.to contain_service('puppet').with({
              'ensure' => 'running',
              'enable' => true,
            })
          end
        end

        context 'when service stopped' do
          let(:params) {{
            :service_ensure => 'stopped',
          }}

          it do
            is_expected.to contain_service('puppet').with({
              'ensure' => 'stopped',
              'enable' => true,
            })
          end
        end
      end
    end
  end
end
