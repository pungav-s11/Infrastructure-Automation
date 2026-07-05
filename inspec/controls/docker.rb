control 'docker-installation' do
  impact 1.0
  title 'Verify Docker Installation'

  describe package('docker.io') do
    it { should be_installed }
  end

  describe service('docker') do
    it { should be_enabled }
    it { should be_running }
  end

  describe command('docker --version') do
    its('exit_status') { should eq 0 }
  end
end