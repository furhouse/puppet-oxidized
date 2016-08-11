require 'spec_helper'

describe 'oxidized' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "oxidized class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('oxidized::params') }
          it { is_expected.to contain_class('oxidized::install').that_comes_before('oxidized::config') }
          it { is_expected.to contain_class('oxidized::config') }
          it { is_expected.to contain_class('oxidized::service').that_subscribes_to('oxidized::config') }

          it { is_expected.to contain_service('oxidized') }
          it { is_expected.to contain_package('oxidized').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'oxidized class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('oxidized') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
