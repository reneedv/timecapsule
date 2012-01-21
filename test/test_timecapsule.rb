require 'helper'

class TestTimecapsule < Test::Unit::TestCase
  
  def cleanup!
    cleanup_db!
    system "rm -rf #{Pathname.new(Timecapsule::EXPORT_DIR).parent}"
    system "rm -rf #{Timecapsule::EXPORT_DIR}"
    system "rm -rf #{Rails.root.join("config")}"
  end
  
  def cleanup_db!
    User.destroy_all
    Post.destroy_all
    User.reset_pk_sequence
    Post.reset_pk_sequence
  end
  
  should "export a model" do
     Timecapsule.export_model(User)
     assert_equal true, File.exists?("#{Timecapsule::EXPORT_DIR}$#{User.to_s.pluralize.underscore}.csv")
     cleanup!
  end
  
  should "import a model" do
    User.create!(:first_name => 'test', :last_name => 'tester')
    assert_equal 1, User.count
    Timecapsule.export_model(User)
    cleanup_db!
    assert_equal 0, User.count
    Timecapsule.import_model(User)
    assert_equal 1, User.count
    assert_equal 'test', User.first.first_name
    cleanup!
  end
  
  should "import all the models" do
    u = User.create!(:first_name => 'test', :last_name => 'tester')
    Post.create!(:title => 'Test Post', :body => 'I like to test my gems!', :user => u)
    assert_equal User.first, Post.first.user
    assert_equal 1, User.count
    assert_equal 1, Post.count
    Timecapsule.export_model(User, 1)
    Timecapsule.export_model(Post, 2)
    cleanup_db!
    assert_equal 0, User.count
    assert_equal 0, Post.count
    Timecapsule.import
    assert_equal 1, User.count
    assert_equal 1, Post.count
    assert_equal 'test', User.first.first_name
    assert_equal 'Test Post', Post.first.title
    assert_equal User.first, Post.first.user
    cleanup!
  end
end
