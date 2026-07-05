control 'common-packages' do
  impact 1.0
  title 'Verify common packages'

  describe package('curl') do
    it { should be_installed }
  end

  describe package('git') do
    it { should be_installed }
  end

  describe package('wget') do
    it { should be_installed }
  end
end