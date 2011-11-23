class Timecapsule

  config = YAML.load_file(Rails.root.join("config/timecapsule.yml"))
  IMPORT_DIR = config[:import_directory] || 'db/seed_data/'
  EXPORT_DIR = config[:export_directory] || 'db/seed_data/'
  
  require 'csv'
  
  def self.import_model(model_import)
    puts "Importing: #{model_import} from #{IMPORT_DIR}#{model_import.to_s.pluralize.underscore}.csv"
    csv = CSV.read(Rails.root.join("#{IMPORT_DIR}#{model_import.to_s.pluralize.underscore}.csv"))
    attributes = csv.shift
    csv.each do |row|
      hash = {}
      attributes.collect{|k| k.to_sym}.each_with_index do |key,i|
        hash[key] = row[i]
      end
      object = model_import.new(hash)
      object.save(false)
    end
  end
  
  def self.import
    @csv_files = Dir.glob("#{IMPORT_DIR}*.csv")
    @csv_files.each do |file|
      model_name = file.split('/').last.split('.').first.classify.constantize
      if model_name.count == 0
        Timecapsule.import_model(model_name)
      end
    end
  end
  
  def self.export_model(model_export)
    puts "Exporting: #{model_export} to #{EXPORT_DIR}#{model_export.to_s.pluralize.underscore}.csv"
    @file = File.open("#{EXPORT_DIR}#{model_export.to_s.pluralize.underscore}.csv", "w")
    @file.puts model_export.first.attributes.collect{|k,v| k}.join(",")
    model_export.all.each do |item|
      @file.puts item.attributes.collect{|k,v| "#{Timecapsule.output(v)}"}.join(",")
    end
  end
  
  def self.output(value)
    if value.is_a?(String)
      return value.gsub(",",'')
    end
    value
  end
  
end