require 'serverspec'
require 'net/ssh'
require 'yaml'

set :backend, :ssh

if ENV['ASK_SUDO_PASSWORD']
  begin
    require 'highline/import'
  rescue LoadError
    fail "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV['SUDO_PASSWORD']
end

properties = YAML.load_file('properties.yaml')
host = ENV['TARGET_HOST']
set_property properties[host]

options = Net::SSH::Config.for(host)

if ENV['SSH_LOGIN_USER'].nil?
  options[:user] ||= Etc.getlogin
else
  options[:user] = ENV['SSH_LOGIN_USER']
end

set :host,        options[:host_name] || host
set :ssh_options, options

# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C' 

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'
