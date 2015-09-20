require 'serverspec_helper'

describe 'selenium::chromedriver' do
  if os[:family] == 'windows'
    describe file('C:/chromedriver/chromedriver.exe') do
      it { should be_file }
    end
  elsif !(os[:family] == 'redhat' && os[:release].split('.')[0] == '6')
    describe file('/usr/bin/chromedriver') do
      it { should be_symlink }
    end
  end
end
