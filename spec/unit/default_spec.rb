require 'spec_helper'

describe 'chromedriver::default' do
  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(file_cache_path: 'C:/chef/cache', platform: 'windows', version: '2008R2') do
        ENV['SYSTEMDRIVE'] = 'C:'
      end.converge(described_recipe)
    end

    it 'creates home directory' do
      expect(chef_run).to create_directory('C:/chromedriver')
    end

    it 'creates sub-directory' do
      expect(chef_run).to create_directory('C:/chromedriver/chromedriver_win32-2.20')
    end

    it 'downloads driver' do
      expect(chef_run).to create_remote_file('download chromedriver').with(
        path: "#{Chef::Config[:file_cache_path]}/chromedriver_win32-2.20.zip",
        source: 'https://chromedriver.storage.googleapis.com/2.20/chromedriver_win32.zip'
      )
    end

    it 'unzips via powershell' do
      expect(chef_run).to_not run_batch('unzip chromedriver').with(
        code: "powershell.exe -nologo -noprofile -command \"& { Add-Type -A "\
          "'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory("\
          "'C:/chef/cache/chromedriver_win32.zip', "\
          "'C:/chromedriver/chromedriver_win32-2.20'); }\"")
    end

    it 'unzips via window_zipfile' do
      expect(chef_run).to_not unzip_windows_zipfile_to('C:/chromedriver/chromedriver_win32-2.20').with(
        source: 'C:/chef/cache/chromedriver_win32.zip'
      )
    end

    it 'links driver' do
      expect(chef_run).to create_link('C:/chromedriver/chromedriver.exe').with(
        to: 'C:/chromedriver/chromedriver_win32-2.20/chromedriver.exe'
      )
    end

    it 'sets PATH' do
      expect(chef_run).to modify_env('chromedriver path').with(
        key_name: 'PATH',
        value: 'C:/chromedriver'
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
      expect(chef_run).to create_directory('/opt/chromedriver/chromedriver_linux64-2.20')
    end

    it 'downloads driver' do
      expect(chef_run).to create_remote_file('download chromedriver').with(
        path: "#{Chef::Config[:file_cache_path]}/chromedriver_linux64-2.20.zip",
        source: 'https://chromedriver.storage.googleapis.com/2.20/chromedriver_linux64.zip'
      )
    end

    it 'unzips driver' do
      expect(chef_run).to_not run_execute('unzip chromedriver')
    end

    it 'installs zip package' do
      expect(chef_run).to install_package('unzip')
    end

    it 'links driver' do
      expect(chef_run).to create_link('/usr/bin/chromedriver').with(
        to: '/opt/chromedriver/chromedriver_linux64-2.20/chromedriver'
      )
    end
  end

  context 'mac_os_x' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        file_cache_path: '/var/chef/cache', platform: 'mac_os_x', version: '10.10').converge(described_recipe)
    end

    it 'creates directory' do
      expect(chef_run).to create_directory('/opt/chromedriver/chromedriver_mac32-2.20')
    end

    it 'downloads driver' do
      expect(chef_run).to create_remote_file('download chromedriver').with(
        path: "#{Chef::Config[:file_cache_path]}/chromedriver_mac32-2.20.zip",
        source: 'https://chromedriver.storage.googleapis.com/2.20/chromedriver_mac32.zip'
      )
    end

    it 'links driver' do
      expect(chef_run).to create_link('/usr/bin/chromedriver').with(
        to: '/opt/chromedriver/chromedriver_mac32-2.20/chromedriver'
      )
    end
  end
end
