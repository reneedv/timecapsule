class Timecapsule
  class Railtie < Rails::Railtie
      config.before_configuration do
        def Timecapsule.check_for_and_make_directory(path)
          return true if File.exists?(path)
          path = Pathname.new(path)
          parent = path.parent
          Timecapsule.check_for_and_make_directory(parent) unless path.parent.parent.root?
          Dir.mkdir(path) unless File.exists?(path)
        end

        default_config = {:import_directory => 'db/seed_data/' , :export_directory => 'db/seed_data/'}
        config_pathname = Rails.root.join("config/timecapsule.yml")
        config_dir_pathname = Rails.root.join("config")
        unless File.exists?(config_pathname)
          Timecapsule.check_for_and_make_directory(config_dir_pathname)
          config_file = File.open(config_pathname, 'w')
          config_file.puts default_config.to_yaml
          config_file.close
        end
        config = YAML.load_file(config_pathname)
        Timecapsule::IMPORT_DIR = Rails.root.join(config[:import_directory]).to_s
        Timecapsule::EXPORT_DIR = Rails.root.join(config[:export_directory]).to_s
      end
  end
end