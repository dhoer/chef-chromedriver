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
name = "chromedriver_#{os}#{bit}-#{version}"

if platform?('windows')
  home = node['chromedriver']['windows']['home']
else
  home = node['chromedriver']['unix']['home']
end

directory home do
  action :create
end

driver_path = "#{home}/#{name}"

directory driver_path do
  action :create
end

cache_path = "#{Chef::Config[:file_cache_path]}/#{name}.zip"

if platform?('windows')
  # TODO: Replace powershell and windows_zipfile with windows_zip
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

exe = platform_family?('windows') ? 'chromedriver.exe' : 'chromedriver'

link "#{home}/#{exe}" do
  to "#{driver_path}/#{exe}"
end

case node['platform_family']
when 'windows'
  env 'chromedriver path' do
    key_name 'PATH'
    action :modify
    delim ::File::PATH_SEPARATOR
    value home
  end
when 'mac_os_x'
  directory '/etc/paths.d' do
    mode 0755
  end

  file '/etc/paths.d/chromedriver' do
    content home
    mode 0755
  end
when 'rhel'
  directory '/etc/profile.d' do
    mode 0755
  end

  file '/etc/profile.d/chromedriver.sh' do
    content "pathmunge #{home}"
    mode 0755
  end
else
  directory '/etc/profile.d' do
    mode 0755
  end

  file '/etc/profile.d/chromedriver.sh' do
    content "export PATH=$PATH:#{home}"
    mode 0755
  end
end
