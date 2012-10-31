class MongoidHelper
  def self.init_mongoid_config!
    if is_mongoid_version_lower_than_3?
      Mongoid.configure.master = Mongo::Connection.new.db('acts_as_list_test')
    else
      Mongoid.load! "#{File.dirname(__FILE__)}/../mongoid.yml"
    end   
  end
  
  def self.clear_collections
    # for mongo_id 2.x.x purposes
    if is_mongoid_version_lower_than_3?
      Mongoid.database.collections.each do |coll|
        coll.remove
      end      
    else
      List.mongo_session.drop
    end
  end
  
  private
  def self.is_mongoid_version_lower_than_3?
    Gem.loaded_specs["mongoid"].version.to_s < "3.0.0"
  end
end