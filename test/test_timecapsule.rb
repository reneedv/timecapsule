require 'helper'

class TestTimecapsule < Test::Unit::TestCase
  should "export a model" do
     u = User.new
     u.first_name = 'test'
     Timecapsule.export_model(User)
     assert_equal File.exists?("#{Timecapsule::EXPORT_DIR}$#{User.to_s.pluralize.underscore}.csv"), true
  end
end
