require 'spec_helper'

describe 'ngircd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "ngircd class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('ngircd::params') }
          it { is_expected.to contain_class('ngircd::install').that_comes_before('ngircd::config') }
          it { is_expected.to contain_class('ngircd::config') }
          it { is_expected.to contain_class('ngircd::service').that_subscribes_to('ngircd::config') }

          it { is_expected.to contain_service('ngircd') }
          it { is_expected.to contain_package('ngircd').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'ngircd class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('ngircd') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
