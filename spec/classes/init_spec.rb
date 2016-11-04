require 'spec_helper'

describe 'puppet', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_anchor('puppet::begin') }
      it { is_expected.to contain_class('puppet::params') }
      it { is_expected.to contain_class('puppet::install') }
      it { is_expected.to contain_class('puppet::config') }
      it { is_expected.to contain_class('puppet::service') }
      it { is_expected.to contain_anchor('puppet::end') }

      describe 'puppet::install' do
        context 'defaults' do
          it do
            is_expected.to contain_package('puppet').with(
              'ensure' => 'present'
            )
          end
        end

        context 'when package latest' do
          let(:params) do
            {
              package_ensure: 'latest'
            }
          end

          it do
            is_expected.to contain_package('puppet').with(
              'ensure' => 'latest'
            )
          end
        end

        context 'when package absent' do
          let(:params) do
            {
              package_ensure: 'absent',
              service_ensure: 'stopped',
              service_enable: false
            }
          end

          it do
            is_expected.to contain_package('puppet').with(
              'ensure' => 'absent'
            )
          end
          it do
            is_expected.to contain_file('puppet.conf').with(
              'ensure'  => 'present',
              'notify'  => 'Service[puppet]',
              'require' => 'Package[puppet]'
            )
          end
          it do
            is_expected.to contain_service('puppet').with(
              'ensure' => 'stopped',
              'enable' => false
            )
          end
        end

        context 'when package purged' do
          let(:params) do
            {
              package_ensure: 'purged',
              service_ensure: 'stopped',
              service_enable: false
            }
          end

          it do
            is_expected.to contain_package('puppet').with(
              'ensure' => 'purged'
            )
          end
          it do
            is_expected.to contain_file('puppet.conf').with(
              'ensure'  => 'absent',
              'notify'  => 'Service[puppet]',
              'require' => 'Package[puppet]'
            )
          end
          it do
            is_expected.to contain_service('puppet').with(
              'ensure' => 'stopped',
              'enable' => false
            )
          end
        end
      end

      describe 'puppet::config' do
        context 'defaults' do
          it do
            is_expected.to contain_file('puppet.conf').with(
              'ensure'  => 'present',
              'notify'  => 'Service[puppet]',
              'require' => 'Package[puppet]'
            )
          end
        end

        context 'when source dir' do
          let(:params) do
            {
              config_dir_source: 'puppet:///modules/puppet/common/etc/puppet'
            }
          end

          it do
            is_expected.to contain_file('puppet.dir').with(
              'ensure'  => 'directory',
              'force'   => false,
              'purge'   => false,
              'recurse' => true,
              'source'  => 'puppet:///modules/puppet/common/etc/puppet',
              'notify'  => 'Service[puppet]',
              'require' => 'Package[puppet]'
            )
          end
        end

        context 'when source dir purged' do
          let(:params) do
            {
              config_dir_purge: true,
              config_dir_source: 'puppet:///modules/puppet/common/etc/puppet'
            }
          end

          it do
            is_expected.to contain_file('puppet.dir').with(
              'ensure'  => 'directory',
              'force'   => true,
              'purge'   => true,
              'recurse' => true,
              'source'  => 'puppet:///modules/puppet/common/etc/puppet',
              'notify'  => 'Service[puppet]',
              'require' => 'Package[puppet]'
            )
          end
        end

        context 'when source file' do
          let(:params) do
            {
              config_file_source: 'puppet:///modules/puppet/common/etc/puppet/puppet.conf'
            }
          end

          it do
            is_expected.to contain_file('puppet.conf').with(
              'ensure'  => 'present',
              'source'  => 'puppet:///modules/puppet/common/etc/puppet/puppet.conf',
              'notify'  => 'Service[puppet]',
              'require' => 'Package[puppet]'
            )
          end
        end

        context 'when content string' do
          let(:params) do
            {
              config_file_string: '# THIS FILE IS MANAGED BY PUPPET'
            }
          end

          it do
            is_expected.to contain_file('puppet.conf').with(
              'ensure'  => 'present',
              'content' => %r{THIS FILE IS MANAGED BY PUPPET},
              'notify'  => 'Service[puppet]',
              'require' => 'Package[puppet]'
            )
          end
        end

        context 'when content template' do
          let(:params) do
            {
              config_file_template: 'puppet/common/etc/puppet/puppet.conf.erb'
            }
          end

          it do
            is_expected.to contain_file('puppet.conf').with(
              'ensure'  => 'present',
              'content' => %r{THIS FILE IS MANAGED BY PUPPET},
              'notify'  => 'Service[puppet]',
              'require' => 'Package[puppet]'
            )
          end
        end

        context 'when content template (custom)' do
          let(:params) do
            {
              config_file_template: 'puppet/common/etc/puppet/puppet.conf.erb',
              config_file_options_hash: {
                'key' => 'value'
              }
            }
          end

          it do
            is_expected.to contain_file('puppet.conf').with(
              'ensure'  => 'present',
              'content' => %r{THIS FILE IS MANAGED BY PUPPET},
              'notify'  => 'Service[puppet]',
              'require' => 'Package[puppet]'
            )
          end
        end
      end

      describe 'puppet::service' do
        context 'defaults' do
          it do
            is_expected.to contain_service('puppet').with(
              'ensure' => 'running',
              'enable' => true
            )
          end
        end

        context 'when service stopped' do
          let(:params) do
            {
              service_ensure: 'stopped'
            }
          end

          it do
            is_expected.to contain_service('puppet').with(
              'ensure' => 'stopped',
              'enable' => true
            )
          end
        end
      end
    end
  end
end
