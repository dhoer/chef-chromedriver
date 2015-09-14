require 'spec_helper'

describe 'chromedriver::default' do
  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(file_cache_path: 'C:/chef/cache', platform: 'windows', version: '2008R2') do |node|
        ENV['SYSTEMDRIVE'] = 'C:'
      end.converge(described_recipe)
    end

    it 'creates home directory' do
      expect(chef_run).to create_directory('C:/chromedriver')
    end

    it 'creates sub-directory' do
      expect(chef_run).to create_directory('C:/chromedriver/chromedriver_win32-2.19')
    end

    it 'downloads driver' do
      expect(chef_run).to create_remote_file('download chromedriver').with(
        path: "#{Chef::Config[:file_cache_path]}/chromedriver_win32-2.19.zip",
        source: 'https://chromedriver.storage.googleapis.com/2.19/chromedriver_win32.zip'
      )
    end

    it 'unzips via powershell' do
      expect(chef_run).to_not run_batch('unzip chromedriver').with(
        code: "powershell.exe -nologo -noprofile -command \"& { Add-Type -A "\
          "'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory("\
          "'C:/chef/cache/chromedriver_win32.zip', "\
          "'C:/chromedriver/chromedriver_win32-2.19'); }\"")
    end

    it 'unzips via window_zipfile' do
      expect(chef_run).to_not unzip_windows_zipfile_to('C:/chromedriver/chromedriver_win32-2.19').with(
        source: 'C:/chef/cache/chromedriver_win32.zip'
      )
    end

    it 'links driver' do
      expect(chef_run).to create_link('C:/chromedriver/chromedriver').with(
        to: 'C:/chromedriver/chromedriver_win32-2.19/chromedriver'
      )
    end

    it 'sets webdriver.chrome.driver env variable' do
      expect(chef_run).to modify_env('webdriver.chrome.driver').with(
        value: 'C:/chromedriver/chromedriver'
      )
    end
  end

  context 'linux' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        file_cache_path: '/var/chef/cache', platform: 'centos', version: '7.0').converge(described_recipe)
    end

    it 'creates home directory' do
      expect(chef_run).to create_directory('/opt/chromedriver')
    end

    it 'creates sub-directory' do
      expect(chef_run).to create_directory('/opt/chromedriver/chromedriver_linux64-2.19')
    end

    it 'downloads driver' do
      expect(chef_run).to create_remote_file('download chromedriver').with(
        path: "#{Chef::Config[:file_cache_path]}/chromedriver_linux64-2.19.zip",
        source: 'https://chromedriver.storage.googleapis.com/2.19/chromedriver_linux64.zip'
      )
    end

    it 'unzips driver' do
      expect(chef_run).to_not run_execute('unzip chromedriver')
    end

    it 'installs zip package' do
      expect(chef_run).to install_package('unzip')
    end

    it 'touch profile.d' do
      expect(chef_run).to create_directory('/etc/profile.d')
    end

    it 'add chromedriver path' do
      expect(chef_run).to create_file('/etc/profile.d/chromedriver.sh')
    end

    it 'links driver' do
      expect(chef_run).to create_link('/opt/chromedriver/chromedriver').with(
        to: '/opt/chromedriver/chromedriver_linux64-2.19/chromedriver'
      )
    end
  end

  context 'mac_os_x' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        file_cache_path: '/var/chef/cache', platform: 'mac_os_x', version: '10.10').converge(described_recipe)
    end

    it 'creates directory' do
      expect(chef_run).to create_directory('/opt/chromedriver/chromedriver_mac32-2.19')
    end

    it 'downloads driver' do
      expect(chef_run).to create_remote_file('download chromedriver').with(
        path: "#{Chef::Config[:file_cache_path]}/chromedriver_mac32-2.19.zip",
        source: 'https://chromedriver.storage.googleapis.com/2.19/chromedriver_mac32.zip'
      )
    end

    it 'set webdriver.chrome.driver env variable' do
      expect(chef_run).to run_execute('launchctl setenv webdriver.chrome.driver "/opt/chromedriver/chromedriver"')
    end

    it 'links driver' do
      expect(chef_run).to create_link('/opt/chromedriver/chromedriver').with(
        to: '/opt/chromedriver/chromedriver_mac32-2.19/chromedriver'
      )
    end
  end
end
