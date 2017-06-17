require 'spec_helper'

describe 'oxidized', :type => :class do
  let(:title) { 'oxidized' }
  let(:facts) { {:concat_basedir => '/path/to/dir'} }
  let(:archive_name) { "oxidized-#{current_version}" }
  let(:config_dir) { '/etc/oxidized' }
  let(:config_file) { "#{config_dir}/config" }
  let(:config_file_fragment) { 'global_oxidized_config' }

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge(super())
        end

        context 'default' do
          let(:params) { { :password => 'oxidized', :gem => true } }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('oxidized::params') }

          describe "oxidized::install" do
            it { is_expected.to contain_class('oxidized::install') }
            if facts[:os]['family'] == 'Debian'
              it { should contain_package('ruby') }
              it { should contain_package('ruby-dev') }
              it { should contain_package('libsqlite3-dev') }
              it { should contain_package('libssl-dev') }
              it { should contain_package('pkg-config') }
              it { should contain_package('cmake') }
              it { should contain_package('libssh2-1-dev') }

              it { should contain_package('oxidized-script') }
              it { should contain_package('oxidized-web') }
              it { should contain_package('oxidized') }

            elsif facts[:os]['family'] == 'RedHat'
              it { should contain_package('ruby') }
              it { should contain_package('gcc') }
              it { should contain_package('libssh2-devel') }
              it { should contain_package('openssl-devel') }
              it { should contain_package('ruby-devel') }
              it { should contain_package('sqlite-devel') }
            end
          end
          describe "oxidized::config" do
            it { is_expected.to contain_class('oxidized::config') }

            it { should contain_group(title).with_ensure('present') }
            it { should contain_group(title).with_system(true) }

            it { should contain_user(title).with_ensure('present') }
            it { should contain_user(title).with_shell('/usr/sbin/nologin') }
            it { should contain_user(title).with_home(config_dir) }
            it { should contain_user(title).with_gid(title) }
            it { should contain_user(title).with_managehome(false) }
            it { should contain_user(title).with_system(true) }

            it { should contain_file(config_dir).with_ensure('directory') }
            it { should contain_file(config_dir).with_owner(title) }
            it { should contain_file(config_dir).with_group(title) }
            it { should contain_file(config_dir).with_mode('0640') }

            it { is_expected.to contain_concat(config_file) }
            it { should contain_concat__fragment(config_file_fragment) }
          end
          describe "oxidized::main" do
            it { is_expected.to contain_class('oxidized::main') }
            it { is_expected.to contain_anchor('oxidized::main::start') }
            it { is_expected.to contain_anchor('oxidized::main::end') }
          end
          describe "oxidized::service" do
            it { is_expected.to contain_class('oxidized::service') }

            it { is_expected.to contain_service(title) }
          end
        end
      end
    end
  end
end
