require 'serverspec_helper'

describe 'selenium::chromedriver' do
  if os[:family] == 'windows'
    describe file('C:/chromedriver/chromedriver') do
      it { should be_symlink }
    end

    describe file('C:/selenium/drivers/chromedriver/chromedriver') do
      it { should be_file }
      it { should be_executable.by_user('root') }
    end
  elsif !(os[:family] == 'redhat' && os[:release].split('.')[0] == '6')
    describe file('/usr/local/chromedriver/chromedriver') do
      it { should be_symlink }
    end

    describe file('/usr/local/chromedriver/chromedriver') do
      it { should be_file }
      it { should be_executable.by_user('root') }
    end
  end
end
