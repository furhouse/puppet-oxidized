require 'spec_helper_acceptance'

describe 'oxidized class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'oxidized': password => 'oxidized' }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe package('ruby') do
      it { is_expected.to be_installed }
    end

    describe package('ruby-dev') do
      it { is_expected.to be_installed }
    end

    describe package('libsqlite3-dev') do
      it { is_expected.to be_installed }
    end

    describe package('libssl-dev') do
      it { is_expected.to be_installed }
    end

    describe package('pkg-config') do
      it { is_expected.to be_installed }
    end

    describe package('cmake') do
      it { is_expected.to be_installed }
    end

    describe package('libssh2-1-dev') do
      it { is_expected.to be_installed }
    end

    describe package('oxidized') do
      it { is_expected.to be_installed.by('gem') }
    end

    describe package('oxidized-script') do
      it { is_expected.to be_installed.by('gem') }
    end

    describe package('oxidized-web') do
      it { is_expected.to be_installed.by('gem') }
    end

    # describe service('oxidized') do
      # it { is_expected.to be_enabled }
      # it { is_expected.to be_running }
    # end
  end
end
