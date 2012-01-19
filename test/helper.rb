require 'rubygems'
gem 'activerecord', '>= 2.3.5'
require 'active_record'
gem 'activesupport', '>= 2.3.5'
require 'active_support'

require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

module Rails
  def self.root
    Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), '..')))
  end
end

ENV["RAILS_ENV"] = "test"
ENV["RAILS_ROOT"] = File.expand_path(File.join(File.dirname(__FILE__), '..'))

require 'timecapsule'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define(:version => 1) do
  create_table :users do |t|
    t.string :first_name 
    t.string :last_name 
    t.string :username
    t.string :password
  end
end

class User < ActiveRecord::Base
end

class Test::Unit::TestCase
end






