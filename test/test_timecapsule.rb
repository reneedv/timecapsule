require 'helper'
require 'rails'

class User < ActiveRecord::Base
  attr_accessor :first_name, :last_name, :username, :password
end

class TestTimecapsule < Test::Unit::TestCase
  should "export a model" do
    flunk('FIGURE OUT HOW TO TEST THIS!!')
    # u = User.new
    # u.first_name = 'test'
    # Timecapsule.export_model(User)
    # assert_equal File.exists?("#{Timecapsule::EXPORT_DIR}#{User.to_s.pluralize.underscore}.csv"), true
  end
end
