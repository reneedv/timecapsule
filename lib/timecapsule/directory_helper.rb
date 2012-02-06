module Timecapsule::DirectoryHelper
  def self.check_for_and_make_directory(path)
    return true if File.exists?(path)
    path = Pathname.new(path)
    parent = path.parent
    Timecapsule.check_for_and_make_directory(parent) unless path.parent.parent.root?
    Dir.mkdir(path) unless File.exists?(path)
  end
end