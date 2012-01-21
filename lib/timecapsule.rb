class Timecapsule
  
  def self.check_for_and_make_directory(path)
    return true if File.exists?(path)
    path = Pathname.new(path)
    parent = path.parent
    Timecapsule.check_for_and_make_directory(parent) unless path.parent.parent.root?
    Dir.mkdir(path) unless File.exists?(path)
  end
  
  default_config = {:import_directory => Rails.root.join('db/seed_data/').to_s , :export_directory => Rails.root.join('db/seed_data/').to_s}
  config_pathname = Rails.root.join("config/timecapsule.yml")
  config_dir_pathname = Rails.root.join("config")
  unless File.exists?(config_pathname)
    Timecapsule.check_for_and_make_directory(config_dir_pathname)
    config_file = File.open(config_pathname, 'w')
    config_file.puts default_config.to_yaml
    config_file.close
  end
  config = YAML.load_file(config_pathname)
  IMPORT_DIR = config[:import_directory]
  EXPORT_DIR = config[:export_directory]
  
  require 'csv'
  
  def self.import_model(model_import, file_name=nil)
    file_name ||= Rails.root.join("#{IMPORT_DIR}$#{model_import.to_s.pluralize.underscore}.csv")
    puts "Importing: #{model_import} from #{file_name}"
    csv = CSV.read(file_name)
    attributes = csv.shift
    csv.each do |row|
      hash = {}
      attributes.collect{|k| k.to_sym}.each_with_index do |key,i|
        hash[key] = row[i]
      end
      object = model_import.new(hash)
      object.save(:validate => false)
    end
  end
  
  def self.import
    @csv_files = Dir.glob("#{IMPORT_DIR}*.csv").sort
    @csv_files.each do |file|
      model_name = file.split('$').last.split('.').first.classify.constantize
      if model_name.count == 0
        Timecapsule.import_model(model_name, file)
      end
    end
  end
  
  def self.export_model(model_export, order=nil)
    Timecapsule.check_for_and_make_directory(EXPORT_DIR)
    puts "Exporting: #{model_export} to #{EXPORT_DIR}#{order.to_s}$#{model_export.to_s.pluralize.underscore}.csv"
    @file = File.open("#{EXPORT_DIR}#{order.to_s}$#{model_export.to_s.pluralize.underscore}.csv", "w")
    @file.puts model_export.column_names.sort.join(",")
    model_export.all.each do |item|
      @file.puts item.attributes.sort.collect{|k,v| "#{Timecapsule.output(v)}"}.join(",")
    end
    @file.close
  end
  
  def self.output(value)
    if value.is_a?(String)
      return value.gsub(",",'')
    end
    value
  end
end