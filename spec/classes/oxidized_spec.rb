require 'spec_helper'

describe 'oxidized', :type => :class do
  let(:title) { 'oxidized' }
  let(:facts) { {:concat_basedir => '/path/to/dir', :root_home => '/root', :gnupg_installed => true,} }
  let(:archive_name) { "oxidized-#{current_version}" }
  let(:config_dir) { "/etc/#{title}" }
  let(:config_file) { "#{config_dir}/config" }
  let(:config_file_header) { "#{config_dir}/config__header" }
  let(:config_file_options) { "#{config_dir}/config__options" }
  let(:routerdb) { "#{config_dir}/router.db" }
  let(:centos6_upstart) { "/etc/init.d/#{title}" }
  let(:systemd_file) { "/etc/systemd/system/#{title}.service" }
  let(:pid_dir) { "/var/run/#{title}" }

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

            elsif facts[:os]['family'] == 'RedHat' && facts[:os]['release']['major'] == '7'
              it { should contain_package('ruby') }
              it { should contain_package('gcc') }
              it { should contain_package('libssh2-devel') }
              it { should contain_package('openssl-devel') }
              it { should contain_package('ruby-devel') }
              it { should contain_package('sqlite-devel') }
            elsif facts[:os]['family'] == 'RedHat' && facts[:os]['release']['major'] == '6'
              it { should contain_package('cmake') }
              it { should contain_rvm_wrapper('oxidized') }
              it { should contain_rvm_gem('ruby-2.1.2/oxidized') }
              it { should contain_rvm_gem('ruby-2.1.2/oxidized-script') }
              it { should contain_rvm_gem('ruby-2.1.2/oxidized-web') }
              # it { should contain_package('gcc') }
              # it { should contain_package('libssh2-devel') }
              # it { should contain_package('openssl-devel') }
              # it { should contain_package('ruby-devel') }
              # it { should contain_package('sqlite-devel') }
            end
          end
          describe "oxidized::config" do
            it { is_expected.to contain_class('oxidized::config') }

            it { should contain_group(title).with_ensure('present') }
            it { should contain_group(title).with_system(true) }

            it { should contain_user(title).with_ensure('present') }
            it { should contain_user(title).with_shell('/bin/false') }
            it { should contain_user(title).with_home(config_dir) }
            it { should contain_user(title).with_gid(title) }
            it { should contain_user(title).with_managehome(false) }
            it { should contain_user(title).with_system(true) }

            it { should contain_file(routerdb).with_ensure('file') }
            it { should contain_file(routerdb).with_owner(title) }
            it { should contain_file(routerdb).with_group(title) }
            it { should contain_file(routerdb).with_mode('0440') }

            it { should contain_file(config_dir).with_ensure('directory') }
            it { should contain_file(config_dir).with_owner(title) }
            it { should contain_file(config_dir).with_group(title) }
            it { should contain_file(config_dir).with_mode('0640') }

            it { is_expected.to contain_concat(config_file) }
            it { should contain_concat__fragment(config_file_header) }
            it { should contain_concat__fragment(config_file_options) }
          end
          describe "oxidized::main" do
            it { is_expected.to contain_class('oxidized::main') }
            it { is_expected.to contain_anchor('oxidized::main::start') }
            it { is_expected.to contain_anchor('oxidized::main::end') }
          end
          describe "oxidized::service" do
            it { is_expected.to contain_class('oxidized::service') }
            it { is_expected.to contain_service(title) }

            it { should contain_file(pid_dir).with_ensure('directory') }
            it { should contain_file(pid_dir).with_owner(title) }
            it { should contain_file(pid_dir).with_group(title) }
            it { should contain_file(pid_dir).with_mode('0711') }

            if facts[:os]['family'] == 'Debian'
              let(:params) { { :password => 'oxidized', :service_provider => 'systemd' } }

              it { should contain_file(systemd_file).with_ensure('file') }
              it { should contain_file(systemd_file).with_owner('root') }
              it { should contain_file(systemd_file).with_group('root') }
              it { should contain_file(systemd_file).with_mode('0644') }
            elsif facts[:os]['family'] == 'RedHat' && facts[:os]['release']['major'] == '7'
              let(:params) { { :password => 'oxidized', :service_provider => 'systemd' } }

              it { should contain_file(systemd_file).with_ensure('file') }
              it { should contain_file(systemd_file).with_owner('root') }
              it { should contain_file(systemd_file).with_group('root') }
              it { should contain_file(systemd_file).with_mode('0644') }
            elsif facts[:os]['family'] == 'RedHat' && facts[:os]['release']['major'] == '6'
              let(:params) { { :password => 'oxidized', :service_provider => 'upstart' } }

              it { should contain_file(centos6_upstart).with_ensure('file') }

              it { should contain_file(centos6_upstart).with_owner('root') }
              it { should contain_file(centos6_upstart).with_group('root') }
              it { should contain_file(centos6_upstart).with_mode('0755') }
            end
          end
        end
      end
    end
  end
end
