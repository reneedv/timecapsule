class Timecapsule::RailsAdapter
  def self.root
    Rails.root
  end
  
  def self.create_and_save_model_from(model_import, hash)
    object = model_import.new(hash)
    object.save(:validate => false)
  end
  
  def self.all_instances_of(model_export)
    model_export.all
  end
  
  def self.get_model(model_name)
    model_name.classify.constantize
  end
  
  def self.model_count(model_import)
    model_import.count
  end
  
end