require 'rubygems'
require 'thread'
require 'active_record'
require 'active_support'
require 'rails'

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

#ActiveRecord::Base.logger = ::Logger.new(StringIO.new)

ENV["RAILS_ENV"] = "test"
ENV["RAILS_ROOT"] = File.expand_path(File.join(File.dirname(__FILE__), '..'))

require 'timecapsule'

class Timecapsule
  default_config = {:import_directory => 'db/seed_data/' , 
                  :export_directory => 'db/seed_data/'}
  IMPORT_DIR ||= default_config[:import_directory]
  EXPORT_DIR ||= default_config[:export_directory]
  def Timecapsule.check_for_and_make_directory(path)
    return true if File.exists?(path)
    path = Pathname.new(path)
    parent = path.parent
    Timecapsule.check_for_and_make_directory(parent) unless path.parent.parent.root?
    Dir.mkdir(path) unless File.exists?(path)
  end
end

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

  create_table :names do |t|
    t.string :name
    t.string :other_name
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

class Name < ActiveRecord::Base
end

class Test::Unit::TestCase
end






