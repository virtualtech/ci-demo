require 'spec_helper'

%w(php php-mbstring).each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe file('/etc/php.ini') do
  its(:content) { should match /^date.timezone = \"Asia\/Tokyo\"/ }
  its(:content) { should match /^default_charset = \"UTF-8\"/ }
  its(:content) { should match /^mbstring.language = Japanese/ }
end
