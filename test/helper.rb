require 'rubygems'
require 'thread'
require 'active_record'
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

ActiveRecord::Base.logger = ::Logger.new(StringIO.new)

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
  
  create_table :posts do |t|
    t.string :title
    t.string :body
    t.integer :user_id 
  end
end

module ActiveRecord
  class Base
    def self.reset_pk_sequence
      new_max = maximum(primary_key) || 0
      update_seq_sql = "update sqlite_sequence set seq = #{new_max} where name = '#{table_name}';"
      ActiveRecord::Base.connection.execute(update_seq_sql)
    end     
  end
end


class User < ActiveRecord::Base
  has_many :posts
end

class Post < ActiveRecord::Base
  belongs_to :user
end

class Test::Unit::TestCase
end






