require 'spec_helper'

describe 'chromedriver::default' do
  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(file_cache_path: CACHE, platform: 'windows', version: '2008R2') do
        ENV['SYSTEMDRIVE'] = 'C:'
      end.converge(described_recipe)
    end

    it 'creates home directory' do
      expect(chef_run).to create_directory('C:/chromedriver')
    end

    it 'creates sub-directory' do
      expect(chef_run).to create_directory("C:/chromedriver/chromedriver_win32-#{VERSION}")
    end

    it 'downloads driver' do
      expect(chef_run).to create_remote_file(
        "download #{Chef::Config[:file_cache_path]}/chromedriver_win32-#{VERSION}.zip"
      ).with(
        path: "#{Chef::Config[:file_cache_path]}/chromedriver_win32-#{VERSION}.zip",
        source: "https://chromedriver.storage.googleapis.com/#{VERSION}/chromedriver_win32.zip"
      )
    end

    it 'unzips via powershell' do
      expect(chef_run).to_not run_powershell_script(
        "unzip #{Chef::Config[:file_cache_path]}/chromedriver_win32-#{VERSION}.zip"
      ).with(
        code: 'Add-Type -A '\
          "'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory("\
          "'C:/chef/cache/chromedriver_win32.zip', "\
          "'C:/chromedriver/chromedriver_win32-#{VERSION}');"
      )
    end

    it 'unzips driver' do
      expect(chef_run).to_not run_execute(
        "unzip #{Chef::Config[:file_cache_path]}/chromedriver_win32-#{VERSION}.zip"
      )
    end

    it 'links driver' do
      expect(chef_run).to create_link('C:/chromedriver/chromedriver.exe').with(
        to: "C:/chromedriver/chromedriver_win32-#{VERSION}/chromedriver.exe"
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
      ChefSpec::SoloRunner.new(file_cache_path: CACHE, platform: 'centos', version: '7.0').converge(described_recipe)
    end

    it 'creates home directory' do
      expect(chef_run).to create_directory('/opt/chromedriver')
    end

    it 'creates sub-directory' do
      expect(chef_run).to create_directory("/opt/chromedriver/chromedriver_linux64-#{VERSION}")
    end

    it 'downloads driver' do
      expect(chef_run).to create_remote_file(
        "download #{Chef::Config[:file_cache_path]}/chromedriver_linux64-#{VERSION}.zip"
      ).with(
        path: "#{Chef::Config[:file_cache_path]}/chromedriver_linux64-#{VERSION}.zip",
        source: "https://chromedriver.storage.googleapis.com/#{VERSION}/chromedriver_linux64.zip"
      )
    end

    it 'unzips driver' do
      expect(chef_run).to_not run_execute(
        "unzip #{Chef::Config[:file_cache_path]}/chromedriver_linux64-#{VERSION}.zip"
      )
    end

    it 'installs zip package' do
      expect(chef_run).to install_package('unzip')
    end

    it 'links driver' do
      expect(chef_run).to create_link('/usr/bin/chromedriver').with(
        to: "/opt/chromedriver/chromedriver_linux64-#{VERSION}/chromedriver"
      )
    end
  end

  context 'mac_os_x' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        file_cache_path: CACHE, platform: 'mac_os_x', version: '10.10'
      ).converge(described_recipe)
    end

    it 'creates directory' do
      expect(chef_run).to create_directory("/opt/chromedriver/chromedriver_mac32-#{VERSION}")
    end

    it 'downloads driver' do
      expect(chef_run).to create_remote_file(
        "download #{Chef::Config[:file_cache_path]}/chromedriver_mac32-#{VERSION}.zip"
      ).with(
        path: "#{Chef::Config[:file_cache_path]}/chromedriver_mac32-#{VERSION}.zip",
        source: "https://chromedriver.storage.googleapis.com/#{VERSION}/chromedriver_mac32.zip"
      )
    end

    it 'unzips driver' do
      expect(chef_run).to_not run_execute(
        "unzip #{Chef::Config[:file_cache_path]}/chromedriver_mac32-#{VERSION}.zip"
      )
    end

    it 'links driver' do
      expect(chef_run).to create_link('/usr/bin/chromedriver').with(
        to: "/opt/chromedriver/chromedriver_mac32-#{VERSION}/chromedriver"
      )
    end
  end
end
