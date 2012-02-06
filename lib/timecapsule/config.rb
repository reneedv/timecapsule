class Timecapsule::Config
   include Timecapsule::DirectoryHelper

     def self.default
       new
     end
     
     def initialize()
       @default_config = {:import_directory => import_directory , :export_directory => export_directory}
       @pathname = RailsAdapter.root.join("config/timecapsule.yml")
       @dir_pathname = RailsAdapter.root.join("config")
     end
     
     attr_accessor :default_config, :pathname, :dir_pathname, :export_directory, :import_directory

     def import_directory
       RailsAdapter.root.join('db/seed_data/').to_s
     end

     def export_directory
       RailsAdapter.root.join('db/seed_data/').to_s
     end
     
     def to_yaml
       @default_config.to_yaml
     end
     
     def get_directories_from_file
       config = YAML.load_file(@pathname)
       @import_directory, @export_directory = config[:import_directory], config[:export_directory]
     end
     
     def create_file_if_needed
       unless File.exists?(@pathname)
         self.check_for_and_make_directory(@dir_pathname)
         config_file = File.open(@pathname, 'w')
         config_file.puts to_yaml
         config_file.close
       end
     end
 end