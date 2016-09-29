require 'net/http'

bit = '32'
case node['platform']
when 'windows'
  os = 'win'
when 'mac_os_x'
  os = 'mac'
else
  os = 'linux'
  bit = '64' if node['kernel']['machine'] == 'x86_64'
end

version = node['chromedriver']['version']
if version == 'LATEST_RELEASE'
  version = Chef::HTTP.new(node['chromedriver']['url']).get('/LATEST_RELEASE').strip
end

name = "chromedriver_#{os}#{bit}-#{version}"
home = platform?('windows') ? node['chromedriver']['windows']['home'] : node['chromedriver']['unix']['home']

directory home do
  action :create
end

driver_path = "#{home}/#{name}"

directory driver_path do
  action :create
end

cache_path = "#{Chef::Config[:file_cache_path]}/#{name}.zip"

if platform?('windows')
  # TODO: Replace batch and windows_zipfile with windows_powershell
  # Fix windows_zipfile - rubyzip failure to allocate memory (requires PowerShell 3 or greater & .NET Framework 4)
  batch 'unzip chromedriver' do
    code "powershell.exe -nologo -noprofile -command \"& { Add-Type -A 'System.IO.Compression.FileSystem';"\
      " [IO.Compression.ZipFile]::ExtractToDirectory('#{cache_path}', '#{driver_path}'); }\""
    action :nothing
    only_if { chromedriver_powershell_version >= 3 }
  end

  windows_zipfile driver_path do
    source cache_path
    action :nothing
    not_if { chromedriver_powershell_version >= 3 }
  end
end

package 'unzip' unless platform?('windows', 'mac_os_x')

execute 'unzip chromedriver' do
  command "unzip -o #{cache_path} -d #{driver_path} && chmod -R 0755 #{driver_path}"
  action :nothing
end

remote_file 'download chromedriver' do
  path cache_path
  source "#{node['chromedriver']['url']}/#{version}/chromedriver_#{os}#{bit}.zip"
  use_etag true
  use_conditional_get true
  notifies :run, 'batch[unzip chromedriver]', :immediately if platform?('windows')
  notifies :unzip, "windows_zipfile[#{driver_path}]", :immediately if platform?('windows')
  notifies :run, 'execute[unzip chromedriver]', :immediately unless platform?('windows')
end

case node['platform_family']
when 'windows'
  link "#{home}/chromedriver.exe" do
    to "#{driver_path}/chromedriver.exe"
  end

  env 'chromedriver path' do
    key_name 'PATH'
    action :modify
    delim ::File::PATH_SEPARATOR
    value home
  end
else # unix
  link '/usr/bin/chromedriver' do
    to "#{driver_path}/chromedriver"
  end
end
