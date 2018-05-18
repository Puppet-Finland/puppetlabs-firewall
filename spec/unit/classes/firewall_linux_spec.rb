require 'spec_helper'

describe 'firewall::linux', type: :class do
  ['RedHat', 'CentOS', 'Fedora'].each do |os|
    context "Redhat Like: operatingsystem => #{os}" do
      releases = ((os == 'Fedora') ? ['14', '15', 'Rawhide'] : ['6', '7'])
      releases.each do |osrel|
        context "operatingsystemrelease => #{osrel}" do
          let(:facts) do
            {
              kernel: 'Linux',
              operatingsystem: os,
              operatingsystemrelease: osrel,
              osfamily: 'RedHat',
              selinux: false,
              puppetversion: Puppet.version,
            }
          end

          it { is_expected.to contain_class('firewall::linux::redhat').with_require('Package[iptables]') }
          it { is_expected.to contain_package('iptables').with_ensure('present') }
        end
      end
    end
  end

  ['Debian', 'Ubuntu'].each do |os|
    context "Debian Like: operatingsystem => #{os}" do
      releases = ((os == 'Debian') ? ['6', '7', '8'] : ['10.04', '12.04', '14.04'])
      releases.each do |osrel|
        let(:facts) do
          {
            kernel: 'Linux',
            operatingsystem: os,
            operatingsystemrelease: osrel,
            osfamily: 'Debian',
            selinux: false,
            puppetversion: Puppet.version,
          }
        end

        it { is_expected.to contain_class('firewall::linux::debian').with_require('Package[iptables]') }
        it { is_expected.to contain_package('iptables').with_ensure('present') }
      end
    end
  end
end
