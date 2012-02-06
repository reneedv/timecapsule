require 'csv'
class Timecapsule
  include Timecapsule::DirectoryHelper
  
  def self.adapter
    @adapter || RailsAdapter
  end
  def self.adapter=(this_one)
    @adapter = this_one
  end
  
  def self.config
    @config ||= begin 
      c = Config.default
      c.create_file_if_needed
      c.get_directories_from_file
      c
    end    
  end
  
  def self.import_model(model_import, file_name=nil)
    return if adapter.model_count(model_import) == 0
    file_name ||= adapter.root.join("#{config.import_directory}$#{model_import.to_s.pluralize.underscore}.csv")
    puts "Importing: #{model_import} from #{file_name}"
    csv = CSV.read(file_name)
    attributes = csv.shift
    csv.each do |row|
      hash = {}
      attributes.collect{|k| k.to_sym}.each_with_index do |key,i|
        hash[key] = row[i]
      end
      adapter.create_and_save_model_from(model_import, hash)
    end
  end
  
  def self.import
    @csv_files = Dir.glob("#{config.import_directory}*.csv").sort
    @csv_files.each do |file|
      if file.include?('$')
        
        rails_model = adapter.get_model(file.split("$").last.split('.').first)
      else
        rails_model = adapter.get_model(file.split('/').last.split('.').first)
      end
      Timecapsule.import_model(rails_model, file)
    end
  end
  
  def self.export_model(model_export, order=nil)
    Timecapsule.check_for_and_make_directory(config.export_directory)
    puts "Exporting: #{model_export} to #{config.export_directory}#{order.to_s}$#{model_export.to_s.pluralize.underscore}.csv"
    @file = File.open("#{config.export_directory}#{order.to_s}$#{model_export.to_s.pluralize.underscore}.csv", "w")
    @file.puts model_export.column_names.sort.join(",")
    adapter::all_instances_of(model_export).each do |item|
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