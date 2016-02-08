require 'spec_helper'

describe file('/var/www/html/index.html') do
  it { should exist }
end

describe file('/var/www/html/phpinfo/phpinfo.php') do
  it { should exist }
end
